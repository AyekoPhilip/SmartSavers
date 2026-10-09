table 50460 "Account Closure Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Account No."; Code[20])
        {
            Editable = false;
            TableRelation = "Account Banking";
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }
        field(50011; "Name"; Text[50])
        {
            Editable = false;
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(50012; "Product Type"; Code[20])
        {
            Editable = false;
            TableRelation = "Product Factory"."Product ID";
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        }
        field(50013; "Balance"; Decimal)
        {
            Editable = false;
            Caption = 'Balance';
            DataClassification = CustomerContent;
        }
        field(50014; "Close"; Boolean)
        {
            Caption = 'Close';
            DataClassification = CustomerContent;
        }
        field(50015; "Member No."; Code[20])
        {
            Editable = false;
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
        field(50016; "Blocked"; Option)
        {
            OptionCaption = ' ,Credit,Debit,All';
            OptionMembers = " ","Credit","Debit","All";
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
        field(50017; "Rejected"; Boolean)
        {
            Caption = 'Rejected';
            DataClassification = CustomerContent;
        }
        field(50018; "Outstanding Interest"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50019; "Outstanding Principal"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50020; "Amount to Post"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50021; "Accrued Interest"; Decimal)
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                case "Account Category" of
                    "Account Category"::"Shares Capital",
                        "Account Category"::"Shares Deposit",
                        "Account Category"::"Specialty Savings":
                        begin
                            "Amount to Post" := (Balance + "Accrued Interest")
                        end else begin
                        Error('Operation not allowed on this account product type');
                    end;
                end;
            end;
        }
        field(50022; "Loan No."; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50023; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
            AutoIncrement = true;
        }
        field(50024; "Account Category"; Enum "ProductAccountCategory")
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50025; "Net Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50026; "Product Class"; Enum "ProductClass")
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key("Key1"; "No.", "Account No.", "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Membershipclosure.Reset;
        Membershipclosure.SetRange(Membershipclosure."No.", "No.");
        Membershipclosure.SetFilter(Membershipclosure."Approval Status", '<>%1', Membershipclosure."Approval Status"::Open);
        if Membershipclosure.Find('-') then begin
            Error(Txt00000);
        end;
    end;

    var
        Membershipclosure: Record "Membership closure";
        Txt00000: Label 'You cannot delete enteries when status is not open';
}




