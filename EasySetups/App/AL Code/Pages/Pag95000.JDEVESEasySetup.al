page 95000 "JDEV-ES Easy Setup"
{
    Caption = 'Easy Setups';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "JDEV-ES Easy Setups";

    layout
    {
        area(Content)
        {
            group(Purchases)
            {
                field("Purchase Vendor"; Rec."Purchase Vendor")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Sell-To Customer to be used with Purchase Orders created for testing.';
                    ShowMandatory = true;
                }
                field("Purchase Item"; Rec."Purchase Item")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default item to be used with Purchase Orders created for testing.';
                    ShowMandatory = true;
                }
                field("Purchase Quantity"; Rec."Purchase Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity to be used with Purchase Orders created for testing.';
                    ShowMandatory = true;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location to be used with Purchase Orders created for testing.  If left blank, then user setup default location code is used.';
                }
                field(Cost; Rec.Cost)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the direct unit cost to be used with Purchase Orders, created for testing, if the purchased item does not have an assigend direct unit cost.';
                }
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Tax Group Code to use with Purchase Orders, created for testing.';
                }
                field("Purchase Receive"; Rec."Purchase Receive")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether or not the receive the Test Purchase Order.';
                }
                field(Invoice; Rec.Invoice)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether or not the purchase order should be invoiced upon creation for testing.';
                }
            }
            group(Sales)
            {
                field("Sales SellTo Customer"; Rec."Sales SellTo Customer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the sell-to customer for the test sales document.';
                    ShowMandatory = true;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the no (Item/Service Item) for the sales document line.';
                    ShowMandatory = true;
                }
                field("Sales Location"; Rec."Sales Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location for the sales document line item.';
                }
                field("Sales Quantity"; Rec."Sales Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity to be used on the sales document line.';
                    ShowMandatory = true;
                }
                field("Sales Tax Group Code"; Rec."Sales Tax Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the tax group code for test sales documents.';
                }
                field("Sales Ship"; Rec."Sales Ship")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether or not to ship the test sales document.';
                }
                field("Sales Invoice"; Rec."Sales Invoice")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether or not to invoice the test sales document.';
                    Enabled = Rec."Sales Ship";
                }
                field("Sales Receive"; Rec."Sales Receive")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether or not to receive the test sales return order.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange("User ID", UserId);
    end;
}