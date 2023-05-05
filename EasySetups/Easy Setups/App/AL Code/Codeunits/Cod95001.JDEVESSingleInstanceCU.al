codeunit 95001 "JDEV-ES Single Instance CU"
{
    SingleInstance = true;

    procedure SetPurchasePostHideDialog(ParamHideDialog: boolean)
    begin
        PurchaseHideDialog := ParamHideDialog;
    end;

    procedure GetPurchasePostHideDialog(): Boolean
    begin
        exit(PurchaseHideDialog);
    end;

    procedure SetSalesPostHideDialog(ParamHideDialog: boolean)
    begin
        SalesHideDialog := ParamHideDialog;
    end;

    procedure GetSalesPostHideDialog(): Boolean
    begin
        exit(SalesHideDialog);
    end;

    var
        PurchaseHideDialog: Boolean;
        SalesHideDialog: Boolean;
}