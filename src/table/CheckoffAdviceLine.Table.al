table 50454 "Checkoff Advice Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Entry No"; Integer)
        {
            Caption = 'Entry No';
            DataClassification = CustomerContent;
        }
        field(50010; "Member No."; Code[100])
        {
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                CustRec: Record Member;
            begin
                Period := Format(Today, 0, Text000);
                if CustRec.Get("Member No.") then
                    Names := CustRec.Name;
            end;
        }
        field(50011; "Account No."; Code[100])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }
        field(50012; "Names"; Text[150])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(50013; "Employer Code"; Code[20])
        {
            TableRelation = Customer;
            Caption = 'Employer Code';
            DataClassification = CustomerContent;
        }
        field(50014; "Loan No."; Code[50])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        }
        field(50015; "Period"; Code[20])
        {
            Caption = 'Period';
            DataClassification = CustomerContent;
        }
        field(50016; "Amount On"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50017; "Amount Off"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50018; "Balance On"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50019; "Balance Off"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50020; "Product Type"; Code[20])
        {
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
            end;
        }
        field(50021; "Advice Date"; Date)
        {
            Caption = 'Advice Date';
            DataClassification = CustomerContent;
        }
        field(50022; "Interest On"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50023; "Advice Method"; Option)
        {
            OptionCaption = 'Changes,Everything';
            OptionMembers = "Changes","Everything";
            Caption = 'Advice Method';
            DataClassification = CustomerContent;
        }
        field(50024; "ID No."; Code[20])
        {
            Caption = 'ID No.';
            DataClassification = CustomerContent;
        }
        field(50025; "Advice Header No."; Code[50])
        {
            Caption = 'Advice Header No.';
            DataClassification = CustomerContent;
        }
        field(50026; "Processed"; Boolean)
        {
            Caption = 'Processed';
            DataClassification = CustomerContent;
        }
        field(50027; "Payroll No"; Code[50])
        {
            Caption = 'Payroll No';
            DataClassification = CustomerContent;
        }
        field(50028; "Advice Type"; Enum "AdviseType")
        {
            Caption = 'Advice Type';
            DataClassification = CustomerContent;
        }
        field(50029; "Product Search Code"; Code[20])
        {
            Caption = 'Product Search Code';
            DataClassification = CustomerContent;
        }
        field(50030; "Document No. Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            Caption = 'Document No. Filter';
        }
        field(50031; "Transfered"; Boolean)
        {
            Caption = 'Transfered';
            DataClassification = CustomerContent;
        }
        field(50032; "Product Name"; Text[100])
        {
            Caption = 'Product Name';
            DataClassification = CustomerContent;
        }
        field(50033; "Employer Account No."; Code[20])
        {
            Caption = 'Employer Account No.';
            DataClassification = CustomerContent;
        }
        field(50034; "Entered By"; Code[100])
        {
            Caption = 'Entered By';
            DataClassification = CustomerContent;
        }
        field(50035; "Source"; Option)
        {
            OptionCaption = 'Loans,Members,Receipts,Account Closure';
            OptionMembers = "Loans","Members","Receipts","Account Closure";
            Caption = 'Source';
            DataClassification = CustomerContent;
        }
        field(50036; "Loan Top Up"; Boolean)
        {
            Caption = 'Loan Top Up';
            DataClassification = CustomerContent;
        }
        field(50037; "Interest Off"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50038; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            DataClassification = CustomerContent;
        }
        field(50039; "Reference"; Code[20])
        {
            Caption = 'Reference';
            DataClassification = CustomerContent;
        }
        field(50040; "Product Cat."; Text[80])
        {
            Editable = false;
            FieldClass = Normal;
            Caption = 'Product Cat.';
            DataClassification = CustomerContent;
        }
        field(50041; "Loan Span"; Option)
        {
            Editable = false;
            FieldClass = Normal;
            OptionCaption = ' ,Short Term,Long Term';
            OptionMembers = " ","Short Term","Long Term";
            Caption = 'Loan Span';
            DataClassification = CustomerContent;
        }
        field(50042; "Repay Mode"; Option)
        {
            Editable = false;
            FieldClass = Normal;
            OptionCaption = ' ,Checkoff,Salary,Dividend,Fixed Deposit';
            OptionMembers = " ","Checkoff","Salary","Dividend","Fixed Deposit";
            Caption = 'Repay Mode';
            DataClassification = CustomerContent;
        }
        field(50043; "Source Code"; Text[80])
        {
            Caption = 'Source Code';
            DataClassification = CustomerContent;
        }
        field(50044; "Sort Code"; Code[20])
        {
            Caption = 'Sort Code';
            DataClassification = CustomerContent;
        }
        field(50045; "Payroll Staff No."; Code[20])
        {
            Editable = false;
            FieldClass = Normal;
            Caption = 'Payroll Staff No.';
            DataClassification = CustomerContent;
        }
        field(50046; "Identity No."; Code[20])
        {
            Editable = false;
            FieldClass = Normal;
            Caption = 'Identity No.';
            DataClassification = CustomerContent;
        }
        field(50047; "Total Loans"; Decimal)
        {
            Editable = false;
            FieldClass = Normal;
            Caption = 'Total Loans';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key("Key1"; "Entry No")
        {
            Clustered = true;
        }
        key("Key2"; "Advice Type")
        {

        }
        key("Key3"; "Payroll No")
        {

        }
        key("Key4"; "Sort Code")
        {

        }
    }

    fieldgroups
    {
    }
    trigger OnInsert()
    begin
        "Entered By" := UserId;
        "Advice Date" := Today;

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnRename()
    begin

    end;

    var
        Text000: Label '<Month Text>';
        Txt0001: Label 'You cannot delete processed advice';


    procedure RestrictAccess(UserNo: Code[100])
    var
        StatusPermission: Record "Status Change Permissions";
        ErrorOnRestrictViewTxt: Label 'You do not have permissions to MODIFY or DELETE on this Page. Contact your system administrator for further details';
    begin
        StatusPermission.Reset;
        StatusPermission.SetRange("User ID", UserNo);
        StatusPermission.SetRange("Edit Data Sheet", true);
        if not StatusPermission.Find('-') then begin
            Error(ErrorOnRestrictViewTxt);
        end;
    end;
}




