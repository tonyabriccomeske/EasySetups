table 95000 "JDEV-ES Easy Setups"
{
    Caption = 'Easy Setups';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Integer)
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            InitValue = 10000;
        }
        field(2; "User ID"; Text[2048])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
            InitValue = UserID;
        }
        field(3; "Purchase Vendor"; Code[20])
        {
            Caption = 'Vendor';
            DataClassification = CustomerContent;
            TableRelation = Vendor;
        }
        field(4; "Purchase Item"; Code[20])
        {
            Caption = 'Item';
            DataClassification = CustomerContent;
            TableRelation = Item;
        }
        field(5; "Purchase Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(6; Location; Code[10])
        {
            Caption = 'Location';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(7; Cost; Decimal)
        {
            Caption = 'Direct Unit Cost';
            DataClassification = CustomerContent;
        }
        field(8; "Tax Group Code"; Code[20])
        {
            Caption = 'Tax Group Code';
            DataClassification = CustomerContent;
            TableRelation = "Tax Group";
        }
        field(9; Invoice; Boolean)
        {
            Caption = 'Invoice';
            DataClassification = CustomerContent;
        }
        field(10; "Sales SellTo Customer"; Code[20])
        {
            Caption = 'Sell-To Customer';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(11; "Sales Tax Group Code"; Code[20])
        {
            Caption = 'Tax Group Code';
            DataClassification = CustomerContent;
            TableRelation = "Tax Group";
        }
        field(14; "Branch Code"; Code[20])
        {
            Caption = 'Bill-To Branch Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(15; "Department Code"; Code[20])
        {
            Caption = 'Bill-To Department Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(16; "Internal Customer"; Code[20])
        {
            Caption = 'Internal Dept. Bill-To Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(17; "Cust %"; Decimal)
        {
            Caption = 'Customer %';
            DataClassification = CustomerContent;
        }
        field(21; "Item No."; code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item;
        }
        field(23; "Sales Location"; Code[10])
        {
            Caption = 'Location';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(24; "Sales Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(25; "Sales Ship"; Boolean)
        {
            Caption = 'Ship';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not Rec."Sales Ship" then
                    Rec."Sales Invoice" := false;
            end;
        }
        field(26; "Sales Invoice"; Boolean)
        {
            Caption = 'Invoice';
            DataClassification = CustomerContent;
        }
        field(27; "Sales Receive"; Boolean)
        {
            Caption = 'Receive';
            DataClassification = CustomerContent;
        }
        field(30; "Vendor Billing Rate"; Decimal)
        {
            Caption = 'Vendor Billing Rate';
            DataClassification = CustomerContent;
        }
        field(32; "Create Fixed Asset"; Boolean)
        {
            Caption = 'Create Fixed Asset';
            DataClassification = CustomerContent;
        }
        field(33; "Purchase Receive"; Boolean)
        {
            Caption = 'Receive';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Code", "User ID")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        Rec."User ID" := "User ID";
    end;
}