codeunit 95002 "JDEV-ES Sales Management"
{
    #region Event Subscribers
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", 'OnBeforeConfirmSalesPost', '', false, false)]
    local procedure JDEV_95002_SalesPostYesNo_OnBeforeConfirmSalesPost(var SalesHeader: Record "Sales Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer; var PostAndSend: Boolean)
    begin
        if GlobJDEVESSingleInstanceCU.GetSalesPostHideDialog() then
            HideDialog := true;
    end;
    #endregion Event Subscribers

    #region Global Procedures
    procedure ES_95002_CreateSalesOrder(ParamDocumentType: enum "Sales Document Type")
    var
        LocItem: Record Item;
        LocJDEVESEasySetups: Record "JDEV-ES Easy Setups";
        LocSalesHeader: Record "Sales Header";
        LocSalesLine: Record "Sales Line";
    begin
        Clear(SerialNoList);
        TestSetupFields(LocJDEVESEasySetups, LocItem);
        CreateSalesHeader(LocSalesHeader, ParamDocumentType, LocJDEVESEasySetups);
        CreateSalesLine(LocSalesHeader, LocSalesLine, LocJDEVESEasySetups, LocItem);

        PostSalesDocument(LocSalesHeader, LocJDEVESEasySetups)
    end;
    #endregion Global Procedures

    #region Local Procedures
    local procedure TestSetupFields(var ParamJDEVESEasySetups: Record "JDEV-ES Easy Setups"; var ParamItem: Record Item)
    begin
        ParamJDEVESEasySetups.Reset();
        ParamJDEVESEasySetups.SetRange("User ID", UserId);
        if ParamJDEVESEasySetups.FindFirst() then;
        ParamJDEVESEasySetups.TestField("Sales SellTo Customer");
        ParamJDEVESEasySetups.TestField("Item No.");
        if ParamJDEVESEasySetups."Sales Quantity" = 0 then
            Error(SalesQuantityErr);
        ParamItem.Get(ParamJDEVESEasySetups."Item No.");
    end;

    local procedure CreateSalesHeader(var ParamSalesHeader: Record "Sales Header"; ParamDocumentType: enum "Sales Document Type"; ParamJDEVESEasySetups: Record "JDEV-ES Easy Setups")
    begin
        ParamSalesHeader.Init();
        ParamSalesHeader.Validate("Document Type", ParamDocumentType);
        ParamSalesHeader.Validate("Sell-to Customer No.", ParamJDEVESEasySetups."Sales SellTo Customer");
        ParamSalesHeader.Validate(Ship, ParamJDEVESEasySetups."Sales Ship");
        ParamSalesHeader.Validate(Invoice, ParamJDEVESEasySetups."Sales Invoice");
        ParamSalesHeader.Validate(Receive, ParamJDEVESEasySetups."Sales Receive");
        ParamSalesHeader."JDEV-ES Created by Easy Setup" := true;

        ParamSalesHeader.Insert(true);
        if ParamJDEVESEasySetups."Sales Location" <> '' then
            ParamSalesHeader.Validate("Location Code", ParamJDEVESEasySetups."Sales Location");
        ParamSalesHeader.Modify(true);
    end;

    local procedure CreateSalesLine(ParamSalesHeader: Record "Sales Header"; var ParamSalesLine: Record "Sales Line"; ParamJDEVESEasySetups: Record "JDEV-ES Easy Setups"; ParamItem: Record Item)
    var
        Discount: Decimal;
        LineNo: Integer;
        LineDiscount: Boolean;
    begin
        Discount := 0;
        LineNo := 10000;

        ParamSalesLine.Init();
        ParamSalesLine.Validate("Document Type", ParamSalesHeader."Document Type");
        ParamSalesLine.Validate("Document No.", ParamSalesHeader."No.");
        ParamSalesLine.Validate("Line No.", LineNo);
        ParamSalesLine.Insert(true);
        ParamSalesLine.Validate(Type, "Sales Line Type"::Item);
        ParamSalesLine.Validate("No.", ParamJDEVESEasySetups."Item No.");
        ParamSalesLine.Validate(Quantity, ParamJDEVESEasySetups."Sales Quantity");
        ParamSalesLine.Validate(Quantity, ParamJDEVESEasySetups."Sales Quantity");
        ParamSalesLine.Validate("Tax Group Code", ParamJDEVESEasySetups."Sales Tax Group Code");
        ParamSalesLine.Modify(true);

        if (ParamItem."Item Tracking Code" <> '') then begin
            ParamSalesLine.Reset();
            ParamSalesLine.SetRange("Document Type", ParamSalesHeader."Document Type");
            ParamSalesLine.SetRange("Document No.", ParamSalesHeader."No.");
            ParamSalesLine.SetRange("No.", ParamItem."No.");
            if ParamSalesLine.FindSet() then
                repeat
                    if ParamSalesLine."Line Discount %" <> 0 then begin
                        LineDiscount := true;
                        Discount := ParamSalesLine."Line Discount %";
                    end;
                until ParamSalesLine.Next() = 0;

            if LineDiscount then begin
                ParamSalesLine.SetRange("Line Discount %", 0);
                if ParamSalesLine.FindSet() then
                    repeat
                        ParamSalesLine.Validate("Line Discount %", Discount);
                        ParamSalesLine.Modify();
                    until ParamSalesLine.Next() = 0;
            end;

        end;
    end;

    local procedure PostSalesDocument(ParamSalesHeader: Record "Sales Header"; ParamJDEVESEasySetups: Record "JDEV-ES Easy Setups")
    var
        LocSalesInvoiceHeader: Record "Sales Invoice Header";
        LocInstructionMgt: Codeunit "Instruction Mgt.";
        LocSalesPostYesNo: Codeunit "Sales-Post (Yes/No)";
    begin
        if ParamSalesHeader."Document Type" in ["Sales Document Type"::Order, "Sales Document Type"::Invoice, "Sales Document Type"::"Return Order"] then
            if (ParamJDEVESEasySetups."Sales Ship") or (ParamJDEVESEasySetups."Sales Invoice") then begin
                GlobJDEVESSingleInstanceCU.SetSalesPostHideDialog(true);
                LocSalesPostYesNo.Run(ParamSalesHeader);
                GlobJDEVESSingleInstanceCU.SetSalesPostHideDialog(false);

                if ParamJDEVESEasySetups."Sales Invoice" then begin
                    LocSalesInvoiceHeader.SetRange("No.", ParamSalesHeader."Last Posting No.");
                    if LocSalesInvoiceHeader.FindFirst() then
                        if LocInstructionMgt.ShowConfirm(StrSubstNo(OpenPostedSalesOrderQst, LocSalesInvoiceHeader."No."), LocInstructionMgt.ShowPostedConfirmationMessageCode()) then
                            Page.Run(PAGE::"Posted Sales Invoice", LocSalesInvoiceHeader);
                end;
            end;
    end;
    #endregion Local Procedures

    var
        GlobJDEVESSingleInstanceCU: Codeunit "JDEV-ES Single Instance CU";
        SerialNoList: List of [Text];
        OpenPostedSalesOrderQst: Label 'The order is posted as number %1 and moved to the Posted Sales Invoices window.\\Do you want to open the posted invoice?', Comment = '%1 = posted document number';
        SalesQuantityErr: Label 'Sales Quantity must have a value greater than 0 in Easy Setups.';
}