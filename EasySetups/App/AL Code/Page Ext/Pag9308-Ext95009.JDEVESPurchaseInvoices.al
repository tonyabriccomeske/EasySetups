pageextension 95009 "JDEV-ES PurchaseInvoices" extends "Purchase Invoices" //9308
{
    layout
    {
        addlast(Control1)
        {
            field("JDEV-ES Created by Easy Setup"; Rec."JDEV-ES Created by Easy Setup")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action("JDEV-ES New PO")
            {
                ApplicationArea = All;
                Caption = 'Create Easy Purchase Invoice';
                ToolTip = 'Specifies the action to create a Purchase Invoice using Easy Setups.';
                Image = CreateDocument;
                Visible = DisplayESAction;

                trigger OnAction()
                var
                    JDEVESPurchaseManagement: Codeunit "JDEV-ES Purchase Management";
                begin
                    JDEVESPurchaseManagement.ES_95000_CreatePurchaseOrder("Purchase Document Type"::Invoice);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        DisplayESAction := false;
        if UserSetup.Get(UserId()) then
            if (UserSetup."JDEV-ES Admin") and (UserSetup."JDEV-ES Test") then
                DisplayESAction := true;
    end;

    var
        DisplayESAction: Boolean;
}