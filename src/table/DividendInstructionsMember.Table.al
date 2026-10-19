table 50373 "Dividend Instructions - Member"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Entry No."; Integer)
        {
            Enabled = false;
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Member No."; Code[10])
        {
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
        field(50011; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee,Saving,Credit,Loan,Prepayment';
            OptionMembers = "G/L Account","Customer","Vendor","Bank Account","Fixed Asset","IC Partner","Employee","Saving","Credit","Loan","Prepayment";
            DataClassification = CustomerContent;
        }
        field(50012; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                          Blocked = CONST(false))
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Account Type" = CONST(Employee)) Employee
            ELSE
            IF ("Account Type" = CONST(Saving)) "Account Banking" WHERE(Blocked = CONST(" "),
                                                                                                                                                          Status = CONST(Active))
            ELSE
            IF ("Account Type" = CONST(Credit)) "Account Credit" WHERE(Blocked = CONST(" "),
                                                                                                                                                                                                                         Status = CONST(Active))
            ELSE
            IF ("Account Type" = CONST(Loan)) "Credit Account" WHERE(Blocked = CONST(" "),
                                                                                                                                                                                                                                                                                      Status = CONST(Active))
            ELSE
            IF ("Account Type" = CONST(Prepayment)) "Repayment Account" WHERE(Blocked = CONST(" "),
                                                                                                                                                                                                                                                                                                                                                            Status = CONST(Active));
            DataClassification = CustomerContent;
        }
        field(50013; "Loan No."; Code[10])
        {
            TableRelation = Loans WHERE("Account No." = FIELD("Member No."));
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        }
        field(50014; "Recovery Type"; Option)
        {
            OptionCaption = ' ,Based on Amount,Based on (%)';
            OptionMembers = " ","Based on Amount","Based on (%)";
            Caption = 'Recovery Type';
            DataClassification = CustomerContent;
        }
        field(50015; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(50016; "Product Type"; Code[10])
        {
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        }
        field(50017; "Sent Online"; Boolean)
        {
            Caption = 'Sent Online';
            DataClassification = CustomerContent;
        }
        field(50018; "Priority"; Integer)
        {
            Caption = 'Priority';
            DataClassification = CustomerContent;
        }
        field(50019; "Recurrent Over Years"; Boolean)
        {
            Caption = 'Recurrent Over Years';
            DataClassification = CustomerContent;
        }
        field(50020; "Last Modified Date"; Date)
        {
            Caption = 'Last Modified Date';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Member No.", "Account No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        "Last Modified Date" := Today;

        DividendInstructionsMember.Reset;
        DividendInstructionsMember.SetRange("Recovery Type", DividendInstructionsMember."Recovery Type"::"Based on (%)");
        DividendInstructionsMember.SetRange("Member No.", DividendInstructionsMember."Member No.");
        if DividendInstructionsMember.Find('-') then begin
            DividendInstructionsMember.CalcSums(Amount);
            if Amount > 100 then
                Error(Err001);
        end;
    end;

    var
        DividendInstructionsMember: Record "Dividend Instructions - Member";
        Err001: Label 'Percentage cannot be more than 100';
}




