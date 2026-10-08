table 50468 "SMS Account Subscription"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[10])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
              
            end;
        }
        field(50010; "Member Creation"; Code[10])
        {
            TableRelation = "SMS Series";
            Caption = 'Member Creation';
            DataClassification = CustomerContent;
        }
        field(50011; "Deposit Confirmation"; Code[10])
        {
            TableRelation = "SMS Series";
            Caption = 'Deposit Confirmation';
            DataClassification = CustomerContent;
        }
        field(50012; "Cash Withdrawal"; Code[10])
        {
            TableRelation = "SMS Series";
            Caption = 'Cash Withdrawal';
            DataClassification = CustomerContent;
        }
        field(50013; "Loan Application"; Code[10])
        {
            TableRelation = "SMS Series";
            Caption = 'Loan Application';
            DataClassification = CustomerContent;
        }
        field(50014; "Loan Guarantors"; Code[10])
        {
            TableRelation = "SMS Series";
            Caption = 'Loan Guarantors';
            DataClassification = CustomerContent;
        }
        field(50015; "Loan Posted"; Code[10])
        {
            TableRelation = "SMS Series";
            Caption = 'Loan Posted';
            DataClassification = CustomerContent;
        }
        field(50016; "Loan defaulted"; Code[10])
        {
            TableRelation = "SMS Series";
            Caption = 'Loan defaulted';
            DataClassification = CustomerContent;
        }
        field(50017; "Salary Posted"; Code[10])
        {
            TableRelation = "SMS Series";
            Caption = 'Salary Posted';
            DataClassification = CustomerContent;
        }
        field(50018; "Fixed Deposit Maturity"; Code[10])
        {
            TableRelation = "SMS Series";
            Caption = 'Fixed Deposit Maturity';
            DataClassification = CustomerContent;
        }
        field(50019; "InterAccount Transfer"; Code[10])
        {
            TableRelation = "SMS Series";
            Caption = 'InterAccount Transfer';
            DataClassification = CustomerContent;
        }
        field(50020; "Account Status"; Code[10])
        {
            TableRelation = "SMS Series";
            Caption = 'Account Status';
            DataClassification = CustomerContent;
        }
        field(50021; "Status Order Creation"; Code[10])
        {
            TableRelation = "SMS Series";
            Caption = 'Status Order Creation';
            DataClassification = CustomerContent;
        }
        field(50022; "EFT Effected"; Code[10])
        {
            TableRelation = "SMS Series";
            Caption = 'EFT Effected';
            DataClassification = CustomerContent;
        }
        field(50023; "ATM Application Failed"; Code[10])
        {
            TableRelation = "SMS Series";
            Caption = 'ATM Application Failed';
            DataClassification = CustomerContent;
        }
        field(50024; "ATM Collection"; Code[10])
        {
            TableRelation = "SMS Series";
            Caption = 'ATM Collection';
            DataClassification = CustomerContent;
        }
        field(50025; "MSACCO"; Code[10])
        {
            TableRelation = "SMS Series";
            Caption = 'MSACCO';
            DataClassification = CustomerContent;
        }
        field(50026; "Member No"; Code[20])
        {
            TableRelation = Member;
            Caption = 'Member No';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if Members.Get("Member No") then begin
                    Name := Members.Name;
                end else
                    Name := '';
            end;
        }
        field(50027; "SMS"; Boolean)
        {
            Caption = 'SMS';
            DataClassification = CustomerContent;
        }
        field(50028; "E-Mail"; Boolean)
        {
            Caption = 'E-Mail';
            DataClassification = CustomerContent;
        }
        field(50029; "Name"; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(50030; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
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
    }

    trigger OnInsert()
    begin

        if "No." = '' then begin
            NoSetup.Get();
            NoSetup.TestField(NoSetup."SMS Subscription");
            
        end;
    end;

    var
        Members: Record Member;
        NoSeriesMgt: Codeunit "No. Series";
        NoSetup: Record "Credit Nos. Series";
}




