pageextension 95001 "JDEV-ES SalesOrderList" extends "Sales Order List" //9305
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
            action("JDEV-ES New SO")
            {
                ApplicationArea = All;
                Caption = 'Create Easy Sales Order';
                ToolTip = 'Specifies the action to create a Sales Order using Easy Setups.';
                Image = CreateDocument;
                Visible = DisplayESAction;

                trigger OnAction()
                var
                    JDEVESSalesManagement: Codeunit "JDEV-ES Sales Management";
                begin
                    JDEVESSalesManagement.ES_95002_CreateSalesOrder(Rec."Document Type");
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