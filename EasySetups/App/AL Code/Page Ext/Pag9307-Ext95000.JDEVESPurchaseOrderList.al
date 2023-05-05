pageextension 95000 "JDEV-ES Purchase Order List" extends "Purchase Order List" //9307
{
    actions
    {
        addlast(processing)
        {
            action("JDEV-ES New PO")
            {
                ApplicationArea = All;
                Caption = 'Create Easy Purchase Order';
                ToolTip = 'Specifies the action to create a Purchase Order using Easy Setups.';
                Image = CreateDocument;
                Visible = DisplayESAction;

                trigger OnAction()
                var
                    JDEVESPurchaseManagement: Codeunit "JDEV-ES Purchase Management";
                begin
                    JDEVESPurchaseManagement.ES_95000_CreatePurchaseOrder(Rec."Document Type");
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