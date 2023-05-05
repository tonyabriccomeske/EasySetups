pageextension 95002 "JDEV-ES User Setup" extends "User Setup" //119
{
    layout
    {
        addafter("User ID")
        {
            field("JDEV-ES JDEVich"; Rec."JDEV-ES Admin")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether or not the user is a JDEVich tester.';
            }
        }
        addlast(Control1)
        {
            field("JDEV-ES Test"; Rec."JDEV-ES Test")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether or not the user is a tester.';
            }
        }
    }
}