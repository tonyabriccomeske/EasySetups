codeunit 95003 "JDEV-ES Utilities"
{
    procedure ES_95003_CreateRandomText(Length: Integer): Text
    var
        GuidTxt: Text;
    begin
        while StrLen(GuidTxt) < Length do
            GuidTxt += LowerCase(DelChr(Format(CreateGuid()), '=', '{}-'));

        exit(CopyStr(GuidTxt, 1, Length));
    end;
}