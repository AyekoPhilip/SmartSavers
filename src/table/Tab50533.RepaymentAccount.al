table 50533 "Repayment Account"
{
    Caption = 'Repayment Accounts';
    DrillDownPageID = "Repayment Account List";
    LookupPageID = "Repayment Account List";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[20])
        {
            Caption = 'No.';
            SQLDataType = Varchar;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
               
            end;
        }
        field(50010; "Name"; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(50011; "Registration Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Registration Date';
        }
        field(50012; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            CharAllowed = '0123456789';
            ExtendedDatatype = PhoneNo;
            DataClassification = CustomerContent;
        }
        field(50013; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50014; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(50015; "Customer Posting Group"; Code[20])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";
            DataClassification = CustomerContent;
        }
        field(50016; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
            DataClassification = CustomerContent;
        }
        field(50017; "Recruited By"; Code[10])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
            DataClassification = CustomerContent;
        }
        field(50018; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;
        }
        field(50019; "Comment"; Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST(Customer),
                                                      "No." = FIELD("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50020; "Blocked"; Enum "Vendor Blocked")
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
        field(50021; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50022; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(50023; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50024; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }

        field(50025; "Balance"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" where("Vendor No." = field("No.")));
            Caption = 'Balance';
            Editable = false;
        }
        field(50026; "Balance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" where("Vendor No." = field("No."), "Posting Date" = field("Date Filter")));
            Caption = 'Balance (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50027; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50028; "Account Category"; Enum "ProductAccountCategory")
        {
            DataClassification = CustomerContent;
            Caption = 'Account Category';
        }
        field(50029; "Currency Filter"; Code[10])
        {
            Caption = 'Currency Filter';
            FieldClass = FlowFilter;
            TableRelation = Currency;
        }
        field(50030; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center BR";
            DataClassification = CustomerContent;
        }
        field(50031; "Status"; Enum "MemberStatus")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50032; "Employer Code"; Code[50])
        {
            Caption = 'Employer Code';
            DataClassification = CustomerContent;
        }
        field(50033; "ID No."; Code[20])
        {
            Caption = 'ID No.';
            DataClassification = CustomerContent;
        }
        field(50034; "Group Account No"; Code[20])
        {
            Caption = 'Group Account No';
            DataClassification = CustomerContent;
        }
        field(50035; "Group Account"; Boolean)
        {
            Caption = 'Group Account';
            DataClassification = CustomerContent;
        }
        field(50036; "Product Type"; Code[20])
        {
            TableRelation = "Product Factory"."Product ID";
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestNoEntriesExist(FieldCaption("No."), "No.")
            end;
        }
        field(50037; "Member No."; Code[20])
        {
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestNoEntriesExist(FieldCaption("No."), "No.")
            end;
        }
        field(50038; "Product Name"; Text[50])
        {
            Caption = 'Product Name';
            DataClassification = CustomerContent;
        }
        field(50039; "Company Registration No."; Code[20])
        {
            Caption = 'Company Registration No.';
            DataClassification = CustomerContent;
        }
        field(50040; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = CustomerContent;
        }
        field(50041; "Withdrawal Option"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Withdrawable,Non-withdrawable';
            OptionMembers = " ","Withdrawable","Non-withdrawable";
            Caption = 'Withdrawal Option';
        }
        field(50042; "Account Dimension"; Enum "AccountDimension")
        {
            DataClassification = CustomerContent;
            Caption = 'Account Dimension';
        }
    }

    keys
    {
        key("Key1"; "No.")
        {
            Clustered = true;
        }
        key("Key2"; "Name")
        {

        }
        key("Key3"; "Global Dimension 1 Code")
        {

        }
        key("Key4"; "Phone No.")
        {

        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SeriesSetup.Get;
            SeriesSetup.TestField(SeriesSetup."Repayment  Nos.");
            
        end;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := Today;
    end;

    var
        Text002: Label 'Do you wish to create a contact for %1 %2?';
        SeriesSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit "No. Series";
        DimMgt: Codeunit DimensionManagement;
        InsertFromContact: Boolean;
        Text004: Label 'post';
        Text005: Label 'create';
        Text006: Label 'You cannot %1 this type of document when Customer %2 is blocked with type %3';
        Text016: Label 'You cannot Modify %1 %2 because there is at least one transaction %3 for this Member.';


    procedure TestNoEntriesExist(CurrentFieldName: Text[100]; GLNo: Code[20])
    var
        MemberLedgEntry: Record "Repayment Ledger Entry";
    begin
        MemberLedgEntry.SetCurrentKey(MemberLedgEntry."Customer No.");
        MemberLedgEntry.SetRange("Customer No.", GLNo);
        if MemberLedgEntry.Find('-') then
            Error(
            Text016,
             CurrentFieldName, "No.", Name);
    end;


    procedure AssistEdit(OldCust: Record "Repayment Account"): Boolean
    var
        Cust: Record "Repayment Account";
    begin
        Cust := Rec;
    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Customer, "No.", FieldNumber, ShortcutDimCode);
        Modify;
    end;


    procedure ShowContact()
    var
        ContBusRel: Record "Contact Business Relation";
        Cont: Record Contact;
    begin
        if "No." = '' then
            exit;

        ContBusRel.SetCurrentKey("Link to Table", "No.");
        ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Customer);
        ContBusRel.SetRange("No.", "No.");
        if not ContBusRel.FindFirst then begin
            if not Confirm(Text002, false, TableCaption, "No.") then
                exit;
            ContBusRel.FindFirst;
        end;
        Commit;

        Cont.SetCurrentKey("Company Name", "Company No.", Type, Name);
        Cont.SetRange("Company No.", ContBusRel."Contact No.");
        PAGE.Run(PAGE::"Contact List", Cont);
    end;


    procedure SetInsertFromContact(FromContact: Boolean)
    begin
        InsertFromContact := FromContact;
    end;


    procedure CheckBlockedCustOnJnls(Cust2: Record "Repayment Account"; DocType: Enum "Gen. Journal Document Type"; Transaction: Boolean)
    begin
        if (Cust2.Blocked = Cust2.Blocked::All) or
   (Cust2.Blocked = Cust2.Blocked::Payment) then
            Cust2.CustBlockedErrorMessage(Cust2, Transaction);
    end;


    procedure CustBlockedErrorMessage(Cust2: Record "Repayment Account"; Transaction: Boolean)
    var
        "Action": Text[30];
    begin
        if Transaction then
            Action := Text004
        else
            Action := Text005;
        Error(Text006, Action, Cust2."No.", Cust2.Blocked);
    end;


    procedure SetStyle(): Text
    begin
    end;


    procedure GetBillToCustomerNo(): Code[20]
    begin
    end;

    procedure CopyFromMemberCustEntries(MemberApplication: Record Member)
    begin

        Validate(Name, MemberApplication.Name);
        "ID No." := MemberApplication."ID No.";
        "Phone No." := MemberApplication."Phone No.";
        Status := Status::New;
        "Registration Date" := Today;
        "Created By" := MemberApplication."Created By";
        "Employer Code" := MemberApplication."Employer Code";
        "Global Dimension 1 Code" := MemberApplication."Global Dimension 1 Code";
        "Global Dimension 2 Code" := MemberApplication."Global Dimension 2 Code";
        "Group Account No" := MemberApplication."Group Account No.";
        "Group Account" := MemberApplication."Group Account";
    end;

    procedure CopyFromMemberApplicationEntries(MemberApplication: Record "Member Application")
    begin

        Validate(Name, MemberApplication.Name);
        "ID No." := MemberApplication."ID No.";
        "Phone No." := MemberApplication."Phone No.";
        Status := Status::New;
        "Registration Date" := Today;
        "Created By" := MemberApplication."Created By";
        "Employer Code" := MemberApplication."Employer Code";
        "Global Dimension 1 Code" := MemberApplication."Global Dimension 1 Code";
        "Global Dimension 2 Code" := MemberApplication."Global Dimension 2 Code";
        "Group Account No" := MemberApplication."Group Account No.";
        "Group Account" := MemberApplication."Group Account";
        OnAfterCopyLinesFromApplicationEntries(MemberApplication, Rec);
    end;


    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyLinesFromApplicationEntries(MemberApplication: Record "Member Application"; var VarVariant: Record "Repayment Account")
    begin
    end;


    procedure CopyFromCustomerMemberEntries(CustomerMember: Record Member)
    begin
        Validate(Name, CustomerMember.Name);
        "Phone No." := CustomerMember."Phone No.";
        Status := Status::New;
        "Registration Date" := Today;
        "Created By" := CustomerMember."Created By";
        "Employer Code" := CustomerMember."Employer Code";
        "Global Dimension 1 Code" := CustomerMember."Global Dimension 1 Code";
        "Global Dimension 2 Code" := CustomerMember."Global Dimension 2 Code";
        "Group Account No" := CustomerMember."Group Account No.";
        "Group Account" := CustomerMember."Group Account";

        OnAfterCopyLinesFromCustomerMemberEntries(CustomerMember, Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyLinesFromCustomerMemberEntries(CustomerMember: Record Member; var VarVariant: Record "Repayment Account")
    begin
    end;
}




