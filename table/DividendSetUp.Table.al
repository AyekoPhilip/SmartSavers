table 50369 "Dividend SetUp"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[10])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Status"; Option)
        {
            OptionMembers = "On Hold","Ready";
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50011; "Loan Arrears Recovery"; Boolean)
        {
            Caption = 'Loan Arrears Recovery';
            DataClassification = CustomerContent;
        }
        field(50012; "Defaulter Recovery"; Boolean)
        {
            Caption = 'Defaulter Recovery';
            DataClassification = CustomerContent;
        }
        field(50013; "Minimum Shares Recovery"; Boolean)
        {
            Caption = 'Minimum Shares Recovery';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if not "Minimum Shares Recovery" then
                    "Minimum Shares Account" := '';
            end;
        }
        field(50014; "Minimum Shares Account"; Code[10])
        {
            TableRelation = "Product Factory" WHERE("Product Class" = CONST(Account));
            Caption = 'Minimum Shares Account';
            DataClassification = CustomerContent;
        }
        field(50015; "Min. Capitalized Method"; Option)
        {
            OptionCaption = ' ,Amount,Status,Both';
            OptionMembers = " ","Amount","Status","Both";
            Caption = 'Min. Capitalized Method';
            DataClassification = CustomerContent;
        }
        field(50016; "Status Filter"; Option)
        {
            FieldClass = FlowFilter;
            OptionMembers = "New","Active","Frozen","Closed","Dormant","Deceased";
            Caption = 'Status Filter';
        }
        field(50017; "Minimum Capitalized"; Decimal)
        {
            Description = 'if Dividend is less than or equal to that amount then system to capitalize earned dividend.';
            Caption = 'Minimum Capitalized';
            DataClassification = CustomerContent;
        }
        field(50018; "Dividend Discounting"; Boolean)
        {
            Caption = 'Dividend Discounting';
            DataClassification = CustomerContent;
        }
        field(50019; "Dividend Instructions"; Boolean)
        {
            Caption = 'Dividend Instructions';
            DataClassification = CustomerContent;
        }
        field(50020; "Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = CustomerContent;
        }
        field(50021; "End Date"; Date)
        {
            Caption = 'End Date';
            DataClassification = CustomerContent;
        }
        field(50022; "Transaction Type"; Code[10])
        {
            TableRelation = "Transaction Types" WHERE(Type = CONST(Dividend));
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
        }
        field(50023; "Total Share Distribute"; Decimal)
        {

            Caption = 'Total Share Distribute';
            DataClassification = CustomerContent;
        }
        field(50024; "Total Qualifying"; Decimal)
        {

            Caption = 'Total Qualifying';
            DataClassification = CustomerContent;
        }
        field(50025; "Total Qualifying Share"; Decimal)
        {

            Caption = 'Total Qualifying Share';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Dividend Progression"."Qualifying Shares");
        }
        field(50026; "Interest On Deposit %"; Decimal)
        {

            Caption = 'Interest On Deposit %';
            DataClassification = CustomerContent;
        }
        field(50027; "Dividend %"; Decimal)
        {
            Caption = 'Dividend %';
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

    trigger OnDelete()
    begin
        RestrictAccess(UserId);
    end;

    trigger OnModify()
    begin
        RestrictAccess(UserId)
    end;


    procedure RestrictAccess(UserNo: Code[100])
    var
        StatusPermission: Record "Status Change Permissions";
        ErrorOnRestrictViewTxt: Label 'You do not have permissions to MODIFY or DELETE on this Page. Contact your system administrator for further details';
    begin
        StatusPermission.Reset;
        StatusPermission.SetRange("User ID", UserNo);
        StatusPermission.SetRange("Edit Setup", true);
        if not StatusPermission.Find('-') then begin
            Error(ErrorOnRestrictViewTxt);
        end;
    end;
}




