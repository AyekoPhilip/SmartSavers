table 50392 "Credit Account"
{
    Caption = 'Credit Account';
    DrillDownPageID = "Loan Account";
    LookupPageID = "Loan Account";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
            SQLDataType = Varchar;
            DataClassification = CustomerContent;
        }
        field(50010; "Name"; Text[250])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(50011; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50012; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(50013; "Customer Posting Group"; Code[20])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";
            DataClassification = CustomerContent;
        }
        field(50014; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
            DataClassification = CustomerContent;
        }
        field(50015; "Blocked"; Option)
        {
            Caption = 'Blocked';
            OptionCaption = ' ,Credit,Debit,All';
            OptionMembers = " ","Credit","Debit","All";
            DataClassification = CustomerContent;
        }
        field(50016; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50017; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(50018; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50019; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50020; "Balance"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount where("Customer No." = field("No."),
            "Posting Date" = field("Date Filter")));
            Caption = 'Balance';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50021; "Balance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" where("Customer No." = field("No."),
            "Posting Date" = field("Date Filter")));
            Caption = 'Balance (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50022; "Net Change"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount where("Customer No." = field("No."),
            "Posting Date" = field("Date Filter"), "Transaction Type" = filter("Interest Due" | "Interest Paid")));
            Caption = 'Outstanding Interest';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50023; "Net Change (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" where("Customer No." = field("No."),
            "Posting Date" = field("Date Filter"), "Transaction Type" = filter("Penalty Due" | "Penalty Paid")));
            Caption = 'Outstanding Bills';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50024; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50025; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center BR";
            DataClassification = CustomerContent;
        }
        field(50026; "Status"; Enum "MemberStatus")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50027; "Employer Code"; Code[50])
        {
            Caption = 'Employer Code';
            DataClassification = CustomerContent;
        }
        field(50028; "ID No."; Code[20])
        {
            Caption = 'ID No.';
            DataClassification = CustomerContent;
        }
        field(50029; "Product Type"; Code[20])
        {
            TableRelation = "Product Factory"."Product ID";
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        }
        field(50030; "Member No."; Code[20])
        {
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
        field(50031; "Product Name"; Text[50])
        {
            Caption = 'Product Name';
            DataClassification = CustomerContent;
        }
        field(50032; "Created By"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
            Caption = 'Created By';
            DataClassification = CustomerContent;
        }
        field(50033; "Date Created"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Date Created';
        }
        field(50034; "Last Modified By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup";
            Caption = 'Last Modified By';
        }
        field(50035; "Account Dimension"; Enum "AccountDimension")
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Account Dimension';
        }
          field(50036; "Old Member No."; Code[100])
        {
            Caption = 'Old Member No.';
            Editable=false;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Name, "Product Name")
        {

        }
    }

    trigger OnDelete()
    begin
        "Last Date Modified" := Today;
        "Last Modified By" := UserId;
    end;

    trigger OnInsert()
    begin
        "Date Created" := CurrentDateTime;
        "Created By" := UserId
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
        "Last Modified By" := UserId;
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := Today;
        "Last Modified By" := UserId;
    end;

    var
        DimMgt: Codeunit DimensionManagement;
        Text004: Label 'post';
        Text005: Label 'create';
        Text006: Label 'You cannot %1 this type of document when Customer %2 is blocked with type %3';
        Text016: Label 'You cannot Modify %1 %2 because there is at least one transaction %3 for this Member.';


    procedure TestNoEntriesExist(CurrentFieldName: Text[100]; GLNO: Code[20])
    var
        MemberLedgEntry: Record "Loan Ledger Entry";
    begin
        MemberLedgEntry.SetCurrentKey(MemberLedgEntry."Customer No.");
        MemberLedgEntry.SetRange(MemberLedgEntry."Customer No.", "No.");
        if MemberLedgEntry.Find('-') then
            Error(
            Text016,
             CurrentFieldName, "No.", Name);
    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Customer, "No.", FieldNumber, ShortcutDimCode);
        Modify;
    end;


    procedure CheckBlockedCustOnJnls(Cust2: Record "Credit Account"; DocType: Enum "Gen. Journal Document Type"; Transaction: Boolean)
    begin
        if (Cust2.Blocked = Cust2.Blocked::All) or
   ((Cust2.Blocked = Cust2.Blocked::Credit) and (DocType in [DocType::Invoice, DocType::" "]))
then
            Cust2.CustBlockedErrorMessage(Cust2, Transaction)
    end;


    procedure CustBlockedErrorMessage(Cust2: Record "Credit Account"; Transaction: Boolean)
    var
        "Action": Text[30];
    begin
        if Transaction then
            Action := Text004
        else
            Action := Text005;
        Error(Text006, Action, Cust2."No.", Cust2.Blocked);
    end;


    procedure CopyFromProductFactory(ProductFactory: Record "Product Factory")
    begin
        "Product Type" := ProductFactory."Product ID";
        "Product Name" := ProductFactory.Description;
        "Global Dimension 1 Code" := ProductFactory."Shortcut Dimension 1 Code";
        "Global Dimension 2 Code" := ProductFactory."Shortcut Dimension 2 Code";
        "Customer Posting Group" := ProductFactory."Posting Group";
        "Account Dimension" := ProductFactory."Account Dimension";
    end;
}




