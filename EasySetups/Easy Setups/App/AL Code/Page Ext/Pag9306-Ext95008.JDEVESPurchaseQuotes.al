pageextension 95008 "JDEV-ES Purchase Quotes" extends "Purchase Quotes" //9306
{
    actions
    {
        addlast(processing)
        {
            action("JDEV-ES New PO")
            {
                ApplicationArea = All;
                Caption = 'Create Easy Purchase Quote';
                ToolTip = 'Specifies the action to create a Purchase Quote using Easy Setups.';
                Image = CreateDocument;
                Visible = DisplayESAction;

                trigger OnAction()
                var
                    JDEVESPurchaseManagement: Codeunit "JDEV-ES Purchase Management";
                begin
                    JDEVESPurchaseManagement.ES_95000_CreatePurchaseOrder("Purchase Document Type"::Quote);
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