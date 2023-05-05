pageextension 95009 "JDEV-ES Purchase Invoices" extends "Purchase Invoices" //9308
{
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
        UserSetup.Get(UserId());
        if (UserSetup."JDEV-ES Admin") and (UserSetup."JDEV-ES Test") then
            DisplayESAction := true;
    end;

    var
        DisplayESAction: Boolean;
}