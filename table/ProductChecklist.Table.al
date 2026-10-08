table 50502 "Product Checklist"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Product Code"; Code[20])
        {
            Caption = 'Product Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Mandatory Requirement"; Option)
        {
            OptionCaption = ' ,Salary,Business Income,Member Deposits,Collateral or Guarantors';
            OptionMembers = " ","Salary","Business Income","Member Deposits","Collateral or Guarantors";
            Caption = 'Mandatory Requirement';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Product Code", "Mandatory Requirement")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




