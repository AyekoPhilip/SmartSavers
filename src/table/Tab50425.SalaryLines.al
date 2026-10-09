table 50425 "Salary Lines"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Integer)
        {
            AutoIncrement = true;
            NotBlank = false;
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Account No."; Code[20])
        {
            TableRelation = "Account Banking"."No.";
            ValidateTableRelation = false;
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                Acc.Reset;
                Acc.SetRange(Acc."No.", "Account No.");
                if Acc.Find('-') then begin
                    if "Staff No." = '' then
                        "Staff No." := Acc."Staff/Payroll No.";
                    "Member No." := Acc."Member No.";
                    Status := Acc.Status;
                    Blocked := Acc.Blocked;
                    Name := Acc.Name;
                end;

                if "Account No." = '' then begin
                    "Member No." := '';
                    Name := '';
                    Amount := 0;
                end;
            end;
        }
        field(50011; "Staff No."; Code[20])
        {
            Caption = 'Staff No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                Acc.Reset;
                Acc.SetRange(Acc."Staff/Payroll No.", "Staff No.");
                if Acc.Find('-') then begin
                    if "Account No." = '' then
                        "Account No." := Acc."No.";
                    "Member No." := Acc."Member No.";
                    Status := Acc.Status;
                    Blocked := Acc.Blocked;
                    Name := Acc.Name;
                end;
            end;
        }
        field(50012; "Name"; Text[50])
        {
            Editable = false;
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(50013; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(50014; "Account Not Found"; Boolean)
        {
            Editable = false;
            Caption = 'Account Not Found';
            DataClassification = CustomerContent;
        }
        field(50015; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            Caption = 'Date Filter';
        }
        field(50016; "Processed"; Boolean)
        {
            Caption = 'Processed';
            DataClassification = CustomerContent;
        }
        field(50017; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(50018; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(50019; "Multiple Salary"; Boolean)
        {
            Caption = 'Multiple Salary';
            DataClassification = CustomerContent;
        }
        field(50020; "Reversed"; Boolean)
        {
            Caption = 'Reversed';
            DataClassification = CustomerContent;
        }
        field(50021; "Account Name"; Text[50])
        {
            Caption = 'Account Name';
            DataClassification = CustomerContent;
        }
        field(50022; "ID No."; Code[30])
        {
            Editable = true;
            Caption = 'ID No.';
            DataClassification = CustomerContent;
        }
        field(50023; "Closed"; Boolean)
        {
            Caption = 'Closed';
            DataClassification = CustomerContent;
        }
        field(50024; "Blocked Accounts"; Boolean)
        {
            Editable = false;
            Caption = 'Blocked Accounts';
            DataClassification = CustomerContent;
        }
        field(50025; "Salary Header No."; Code[50])
        {
            Caption = 'Salary Header No.';
            DataClassification = CustomerContent;
        }
        field(50026; "Employer Code"; Code[50])
        {
            Editable = false;
            Caption = 'Employer Code';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                /*
               IF "Employer Code"<> SalProcessingHeader."Employer Code" THEN  BEGIN
               "Employer/ Staff Mismatch":=TRUE;
               MODIFY;
               END;
               */

            end;
        }
        field(50027; "Employer/ Staff Mismatch"; Boolean)
        {
            Caption = 'Employer/ Staff Mismatch';
            DataClassification = CustomerContent;
        }
        field(50028; "Member No."; Code[20])
        {
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
        field(50029; "Status"; Enum "MemberStatus")
        {
            Editable = false;
            Caption = 'Status';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                //IF (Status<>Status::New) OR (Status<>Status::Closed) THEN
                //Blocked:=Blocked::All;
            end;
        }
        field(50030; "Blocked"; Enum "Vendor Blocked")
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
        field(50031; "Posted"; Boolean)
        {
            Editable = false;
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50032; "Posted By"; Code[30])
        {
            Caption = 'Posted By';
            DataClassification = CustomerContent;
        }
        field(50033; "Posting Date"; Date)
        {
            Editable = false;
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(50034; "Posting Time"; Time)
        {
            Editable = false;
            Caption = 'Posting Time';
            DataClassification = CustomerContent;
        }
        field(50035; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1,Blocked);
            end;
        }
        field(50036; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2,"Last Date Modified");
            end;
        }
        field(50037; "Partial Charged STO"; Boolean)
        {
            Caption = 'Partial Charged STO';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Salary Header No.", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Acc: Record "Account Banking";
}




