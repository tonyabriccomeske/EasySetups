pageextension 95005 "JDEV-ES SalesInvoiceList" extends "Sales Invoice List" //9301
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
                Caption = 'Create Easy Sales Invoice';
                ToolTip = 'Specifies the action to create a Sales Invoice using Easy Setups.';
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