table 50568 "Account (Member)"
{
    Caption = 'Account Credit-Temp';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
            SQLDataType = Varchar;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestNoEntriesExist(FieldCaption("No."), "No.");
            end;
        }
        field(50010; "Name"; Text[150])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if ("Search Name" = UpperCase(xRec.Name)) or ("Search Name" = '') then
                    "Search Name" := UpperCase(Name);
            end;
        }
        field(50011; "Search Name"; Code[50])
        {
            Caption = 'Search Name';
            DataClassification = CustomerContent;
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
        field(50015; "Customer Posting Group"; Code[10])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestNoEntriesExist(FieldCaption("No."), "No.");
            end;
        }
        field(50016; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
            DataClassification = CustomerContent;
        }
        field(50017; "Comment"; Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST(Customer),
                                                      "No." = FIELD("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50018; "Blocked"; Option)
        {
            Caption = 'Blocked';
            OptionCaption = ' ,Credit,Debit,All';
            OptionMembers = " ","Credit","Debit","All";
            DataClassification = CustomerContent;
        }
        field(50019; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50020; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(50021; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50022; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50023; "Balance"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Credits A/c Ledger Entry".Amount WHERE("Customer No." = FIELD("No.")));
            Caption = 'Balance';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50024; "Balance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Credits A/c Ledger Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                                                                                "Posting Date" = FIELD("Date Filter")));
            Caption = 'Balance (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50025; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50026; "Currency Filter"; Code[10])
        {
            Caption = 'Currency Filter';
            FieldClass = FlowFilter;
            TableRelation = Currency;
        }
        field(50027; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center BR";
            DataClassification = CustomerContent;
        }
        field(50028; "Status"; Option)
        {
            OptionCaption = ' ,New,Active,Dormant,Frozen,Withdrawal Application,Withdrawn,Deceased,Defaulter,Closed,Blocked';
            OptionMembers = " ","New","Active","Dormant","Frozen","Withdrawal Application","Withdrawn","Deceased","Defaulter","Closed","Blocked";
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50029; "Monthly Contribution"; Decimal)
        {
            Caption = 'Monthly Contribution';
            DataClassification = CustomerContent;
        }
        field(50030; "Group Account No."; Code[20])
        {
            Caption = 'Group Account No.';
            DataClassification = CustomerContent;
        }
        field(50031; "Group Account"; Boolean)
        {
            Caption = 'Group Account';
            DataClassification = CustomerContent;
        }
        field(50032; "Product Type"; Code[20])
        {
            TableRelation = "Product Factory"."Product ID";
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if ProductFactory.Get("Product Type") then
                    "Product Name" := ProductFactory.Description;
            end;
        }
        field(50033; "Member No."; Code[20])
        {
            TableRelation = Member;
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
        field(50034; "Product Name"; Text[50])
        {
            Caption = 'Product Name';
            DataClassification = CustomerContent;
        }
        field(50035; "Can Guarantee Loan"; Boolean)
        {
            Caption = 'Can Guarantee Loan';
            DataClassification = CustomerContent;
        }
        field(50036; "ID/Passport No."; Code[20])
        {
            Caption = 'ID/Passport No.';
            DataClassification = CustomerContent;
        }
        field(50037; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = CustomerContent;
        }
        field(50038; "Registration Date"; Date)
        {
            Caption = 'Registration Date';
            DataClassification = CustomerContent;
        }
        field(50039; "Account Category"; Enum "ProductAccountCategory")
        {
            Caption = 'Account Category';
            DataClassification = CustomerContent;
        }
        field(50040; "Mobile No."; Text[30])
        {
            Caption = 'Mobile No.';
            DataClassification = CustomerContent;
        }
        field(50041; "Last Transaction Date"; Date)
        {
            CalcFormula = Max("Banking A/c Ledger Entry"."Posting Date" WHERE("Customer No." = FIELD("No.")));
            FieldClass = FlowField;
            Caption = 'Last Transaction Date';
        }
        field(50042; "Document No. Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            Caption = 'Document No. Filter';
        }
        field(50043; "Available Shares"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Available Shares';
        }
        field(50044; "Withdrawal Option"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Withdrawable,Non-withdrawable';
            OptionMembers = " ","Withdrawable","Non-withdrawable";
            Caption = 'Withdrawal Option';
        }
        field(50045; "Date of Birth"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date of Birth';
        }
        field(50046; "Employer Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
            Caption = 'Employer Code';
        }
        field(50047; "Account Dimension"; Enum "AccountDimension")
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Account Dimension';
        }
        field(50048; "Staff/Payroll No."; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Staff/Payroll No.';
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
        fieldgroup(DropDown; "No.", Name, "Employer Code")
        {
        }
    }

    trigger OnDelete()
    begin
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
        DimMgt: Codeunit DimensionManagement;
        Text004: Label 'post';
        Text005: Label 'create';
        Text006: Label 'You cannot %1 this type of document when Customer %2 is blocked with type %3';
        ProductFactory: Record "Product Factory";
        Text016: Label 'You cannot Modify %1 %2 because there is at least one transaction %3 for this Member.';


    procedure TestNoEntriesExist(CurrentFieldName: Text[100]; GLNO: Code[20])
    var
        MemberLedgEntry: Record "Credits A/c Ledger Entry";
    begin
        MemberLedgEntry.SetCurrentKey(MemberLedgEntry."Customer No.");
        MemberLedgEntry.SetRange(MemberLedgEntry."Customer No.", "No.");
        if MemberLedgEntry.Find('-') then
            Error(
            Text016,
             CurrentFieldName, "No.", Name);
    end;


    procedure AssistEdit(OldCust: Record "Account (Member)"): Boolean
    begin
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


    procedure CheckBlockedCustOnJnls(Cust2: Record "Account (Member)"; DocType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund; Transaction: Boolean)
    begin
        if (Cust2.Blocked = Cust2.Blocked::All) or
   ((Cust2.Blocked = Cust2.Blocked::Debit) and (DocType in [DocType::Invoice, DocType::" "]))
then
            Cust2.CustBlockedErrorMessage(Cust2, Transaction)
    end;


    procedure CustBlockedErrorMessage(Cust2: Record "Account (Member)"; Transaction: Boolean)
    var
        "Action": Text[30];
    begin
        if Transaction then
            Action := Text004
        else
            Action := Text005;
        Error(Text006, Action, Cust2."No.", Cust2."Balance (LCY)");
    end;


    procedure GetSMSFieldName(SavingsAccounts: Record "Account (Member)") RetunField: Text[20]
    var
        SMSCodes: Record "SMS Codes";
        TableName: Text;
        i: Integer;
        FieldName: array[5] of Text;
    begin
        TableName := SavingsAccounts.TableName;
        i := 1;
        SMSCodes.Reset;
        SMSCodes.SetRange(SMSCodes."Table Name", TableName);
        if SMSCodes.Find('-') then begin
            repeat
                SMSCodes.CalcFields(SMSCodes."Field Name");
                FieldName[i] := SMSCodes."Field Name";
                i += i;
            until SMSCodes.Next = 0;
            RetunField := Format(FieldName[1]) + '[' + Format(FieldName[2]) + '['
            + Format(FieldName[3]) + '[' + Format(FieldName[4]) + '[' + Format(FieldName[5]);
        end;
    end;


    procedure CopyFromMemberApplicationEntries(MemberApplication: Record "Member Application")
    begin

        Validate(Name, MemberApplication.Name);
        "ID/Passport No." := MemberApplication."ID No.";
        "Phone No." := MemberApplication."Phone No.";
        "Mobile No." := MemberApplication."Mobile Phone No";
        Status := Status::New;
        "Registration Date" := Today;
        "Date of Birth" := MemberApplication."Date of Birth";
        "Created By" := MemberApplication."Created By";
        "Employer Code" := MemberApplication."Employer Code";
        "Global Dimension 1 Code" := MemberApplication."Global Dimension 1 Code";
        "Global Dimension 2 Code" := MemberApplication."Global Dimension 2 Code";
        "Group Account No." := MemberApplication."Group Account No.";
        "Group Account" := MemberApplication."Group Account";
        "Staff/Payroll No." := MemberApplication."Payroll No.";
    end;


    procedure CopyFromCustomerMemberEntries(CustomerMember: Record Member)
    begin
        Validate(Name, CustomerMember.Name);
        "ID/Passport No." := CustomerMember."ID No.";
        "Phone No." := CustomerMember."Phone No.";
        "Mobile No." := CustomerMember."Mobile Phone No";
        Status := Status::New;
        "Registration Date" := Today;
        "Date of Birth" := CustomerMember."Date of Birth";
        "Created By" := CustomerMember."Created By";
        "Employer Code" := CustomerMember."Employer Code";
        "Global Dimension 1 Code" := CustomerMember."Global Dimension 1 Code";
        "Global Dimension 2 Code" := CustomerMember."Global Dimension 2 Code";
        "Group Account No." := CustomerMember."Group Account No.";
        "Group Account" := CustomerMember."Group Account";
    end;
}




