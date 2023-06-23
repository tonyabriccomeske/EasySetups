codeunit 95000 "JDEV-ES Purchase Management"
{
    #region Event Subscribers
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnBeforeConfirmPost', '', false, false)]
    local procedure JDEV_95000_PurchPostYesNo_OnBeforeConfirmPost(var PurchaseHeader: Record "Purchase Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer)
    begin
        if JDEVESSingleInstanceCU.GetPurchasePostHideDialog() then
            HideDialog := true;
    end;
    #endregion Event Subscribers

    #region Global Procedures
    procedure ES_95000_CreatePurchaseOrder(ParamDocumentType: Enum "Purchase Document Type")
    var
        Item: Record Item;
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        JDEVESEasySetups: Record "JDEV-ES Easy Setups";
        UserSetup: Record "User Setup";
        PurchPostYesNo: Codeunit "Purch.-Post (Yes/No)";
    begin
        Clear(SerialNoList);

        TestEasySetupFields(JDEVESEasySetups);
        UserSetup.Get(UserId());
        CreatePurchaseHeader(PurchaseHeader, JDEVESEasySetups, ParamDocumentType);
        CreatePurchaseLine(PurchaseLine, PurchaseHeader, Item, JDEVESEasySetups);

        if PurchaseHeader."Document Type" in ["Purchase Document Type"::Order, "Purchase Document Type"::Invoice, "Purchase Document Type"::"Return Order"] then
            if (PurchaseHeader.Ship) or (PurchaseHeader.Invoice) or (PurchaseHeader.Receive) then
                if not ((PurchaseHeader."Document Type" in ["Purchase Document Type"::"Return Order", "Purchase Document Type"::"Credit Memo"]) and (Item."Item Tracking Code" <> '')) then begin
                    JDEVESSingleInstanceCU.SetPurchasePostHideDialog(true);
                    Commit();
                    PurchPostYesNo.Run(PurchaseHeader);
                    JDEVESSingleInstanceCU.SetPurchasePostHideDialog(false);
                end;
    end;
    #endregion Global Procedures

    #region Local Procedures
    local procedure TestEasySetupFields(var ParamJDEVESEasySetups: Record "JDEV-ES Easy Setups")
    begin
        ParamJDEVESEasySetups.SetRange("User ID", UserId());
        ParamJDEVESEasySetups.FindFirst();
        ParamJDEVESEasySetups.TestField("Purchase Item");
        ParamJDEVESEasySetups.TestField("Purchase Vendor");
        ParamJDEVESEasySetups.TestField("Purchase Quantity");
    end;

    local procedure CreatePurchaseHeader(var ParamPurchaseHeader: Record "Purchase Header"; ParamJDEVESEasySetups: Record "JDEV-ES Easy Setups"; ParamDocumentType: Enum "Purchase Document Type")
    begin
        ParamPurchaseHeader.Init();
        ParamPurchaseHeader.Validate("Document Type", ParamDocumentType);
        ParamPurchaseHeader.Validate("Buy-from Vendor No.", ParamJDEVESEasySetups."Purchase Vendor");
        ParamPurchaseHeader."JDEV-ES Created by Easy Setup" := true;
        ParamPurchaseHeader.Insert(true);


        if ParamJDEVESEasySetups.Location <> '' then
            ParamPurchaseHeader.Validate("Location Code", ParamJDEVESEasySetups.Location);

        ParamPurchaseHeader.Validate(Receive, ParamJDEVESEasySetups."Purchase Receive");

        if ParamPurchaseHeader."Document Type" in ["Purchase Document Type"::"Return Order"] then
            ParamPurchaseHeader.Validate(Ship, true);

        if ParamJDEVESEasySetups.Invoice then begin
            ParamPurchaseHeader.Validate(Invoice, ParamJDEVESEasySetups.Invoice);
            if ParamPurchaseHeader."Document Type" in ["Purchase Document Type"::"Return Order"] then
                ParamPurchaseHeader."Vendor Cr. Memo No." := CopyStr(JDEVESUtilities.ES_95003_CreateRandomText(10), 1, MaxStrLen(ParamPurchaseHeader."Vendor Invoice No."));
            ParamPurchaseHeader."Vendor Invoice No." := CopyStr(JDEVESUtilities.ES_95003_CreateRandomText(10), 1, MaxStrLen(ParamPurchaseHeader."Vendor Invoice No."));
        end;

        ParamPurchaseHeader.Modify(true);
    end;

    local procedure CreatePurchaseLine(var ParamPurchaseLine: Record "Purchase Line"; ParamPurchaseHeader: Record "Purchase Header"; var ParamItem: Record Item; ParamJDEVESEasySetups: Record "JDEV-ES Easy Setups")
    var
        LineNo: Integer;
    begin
        LineNo := 10000;
        ParamPurchaseLine.Init();
        ParamPurchaseLine.Validate("Document Type", ParamPurchaseHeader."Document Type");
        ParamPurchaseLine.Validate("Document No.", ParamPurchaseHeader."No.");
        ParamPurchaseLine.Validate("Line No.", LineNo);
        ParamPurchaseLine.Validate(Type, "Purchase Line Type"::Item);
        ParamPurchaseLine.Validate("No.", ParamJDEVESEasySetups."Purchase Item");
        ParamPurchaseLine.Validate(Quantity, ParamJDEVESEasySetups."Purchase Quantity");

        ParamItem.Get(ParamJDEVESEasySetups."Purchase Item");

        if not (ParamPurchaseHeader."Document Type" in ["Purchase Document Type"::"Return Order", "Purchase Document Type"::"Credit Memo"]) then
            if ParamItem."Item Tracking Code" <> '' then
                ParamPurchaseLine.Validate("Qty. to Receive", 1)
            else
                ParamPurchaseLine.Validate("Qty. to Receive", ParamJDEVESEasySetups."Purchase Quantity");

        if ParamJDEVESEasySetups.Cost <> 0 then
            ParamPurchaseLine.Validate("Direct Unit Cost", ParamJDEVESEasySetups.Cost);

        ParamPurchaseLine.Validate("Tax Group Code", ParamJDEVESEasySetups."Tax Group Code");
        ParamPurchaseLine.Insert(true);

        if ParamItem."Item Tracking Code" <> '' then
            SetPurchaseLineSerialNo(ParamPurchaseLine, ParamPurchaseHeader, ParamItem);
    end;

    procedure SetPurchaseLineSerialNo(ParamPurchaseLine: Record "Purchase Line"; ParamPurchaseHeader: Record "Purchase Header"; ParamItem: Record Item)
    var
        LocServiceItem: Record "Service Item";
        SerialNo: Code[50];
        ServiceItemFound: Boolean;
    begin
        if ParamItem."Item Tracking Code" <> '' then begin

            ParamPurchaseLine.Reset();
            ParamPurchaseLine.SetRange("Document Type", ParamPurchaseHeader."Document Type");
            ParamPurchaseLine.SetRange("Document No.", ParamPurchaseHeader."No.");
            if ParamPurchaseLine.FindSet() then
                repeat
                    SerialNo := CopyStr(JDEVESUtilities.ES_95003_CreateRandomText(5), 1, MaxStrLen(SerialNo));
                    LocServiceItem.Reset();
                    LocServiceItem.SetRange("Serial No.", SerialNo);
                    if not LocServiceItem.IsEmpty() then
                        ServiceItemFound := true;
                    while SerialNoList.Contains(SerialNo) or (ServiceItemFound) do begin
                        SerialNo := CopyStr(JDEVESUtilities.ES_95003_CreateRandomText(5), 1, MaxStrLen(SerialNo));
                        LocServiceItem.Reset();
                        LocServiceItem.SetRange("Serial No.", SerialNo);
                        if not LocServiceItem.IsEmpty() then
                            ServiceItemFound := true;
                    end;
                    SerialNoList.Add(SerialNo);
                    ParamPurchaseLine.Validate("Qty. to Receive");
                    ParamPurchaseLine.Modify(true);
                until ParamPurchaseLine.Next() = 0;
        end;
    end;
    #endregion Local Procedures

    var
        JDEVESSingleInstanceCU: Codeunit "JDEV-ES Single Instance CU";
        JDEVESUtilities: Codeunit "JDEV-ES Utilities";
        SerialNoList: List of [Text];
}