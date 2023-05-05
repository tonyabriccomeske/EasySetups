pageextension 95007 "JDEV-ES Sls Rtrn Order List" extends "Sales Return Order List" //9304
{
    actions
    {
        addlast(processing)
        {
            action("JDEV-ES New SO")
            {
                ApplicationArea = All;
                Caption = 'Create Easy Sales Return Order';
                ToolTip = 'Specifies the action to create a Sales Return Order using Easy Setups.';
                Image = CreateDocument;
                Visible = DisplayESAction;

                trigger OnAction()
                var
                    JDEVESSalesManagement: Codeunit "JDEV-ES Sales Management";
                begin
                    JDEVESSalesManagement.ES_95002_CreateSalesOrder("Sales Document Type"::"Return Order");
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