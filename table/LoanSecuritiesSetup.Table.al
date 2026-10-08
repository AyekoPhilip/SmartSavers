table 50472 "Loan Securities Set-up"
{
    DrillDownPageID = "Loan Securities Set-Up";
    LookupPageID = "Loan Securities Set-Up";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Code"; Code[20])
        {
            NotBlank = true;
            Caption = 'Code';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                /*IF LoanApplications.GET(Code) THEN
                Category:=LoanApplications."Loan Product Type";    */

            end;
        }
        field(50010; "Type"; Enum "CollateralType")
        {
            NotBlank = true;
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(50011; "Security Description"; Text[50])
        {
            Caption = 'Security Description';
            DataClassification = CustomerContent;
        }
        field(50012; "Category"; Option)
        {
            OptionCaption = ' ,Cash,Government Securities,Corporate Bonds,Equity,Mortgage Securities,Lien,Motor Vehicle,Others';
            OptionMembers = " ","Cash","Government Securities","Corporate Bonds","Equity","Mortgage Securities","Lien","Motor Vehicle","Others";
            Caption = 'Category';
            DataClassification = CustomerContent;
        }
        field(50013; "Collateral Multiplier"; Integer)
        {
            Caption = 'Collateral Multiplier';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                //"Guarantee Value":="Collateral Multiplier"*0.7;
            end;
        }
        field(50014; "Examples"; Text[250])
        {
            Caption = 'Examples';
            DataClassification = CustomerContent;
        }
        field(50015; "Blocked"; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
        field(50016; "Last Date Modified"; Date)
        {
            Editable = false;
            Caption = 'Last Date Modified';
            DataClassification = CustomerContent;
        }
        field(50017; "Revaluation Frequency"; DateFormula)
        {
            Caption = 'Revaluation Frequency';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", "Security Description")
        {
        }
    }

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
    end;
}




