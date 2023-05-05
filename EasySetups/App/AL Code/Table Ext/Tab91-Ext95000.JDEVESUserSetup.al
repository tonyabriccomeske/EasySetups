tableextension 95000 "JDEV-ES User Setup" extends "User Setup" //91
{
    fields
    {
        field(95000; "JDEV-ES Admin"; Boolean)
        {
            Caption = 'Test Administrator';
            DataClassification = CustomerContent;
        }
        field(95001; "JDEV-ES Test"; Boolean)
        {
            Caption = 'Test Mode';
            DataClassification = CustomerContent;
        }
    }

}