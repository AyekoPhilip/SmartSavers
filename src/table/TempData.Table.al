table 50248 "Temp Data"
{
    Caption = 'Temp Data';
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "No."; Code[100])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(50010; "Account No."; Code[100])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
        }
        field(50011; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(50012; "Description"; Text[150])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(50013; "Application Date"; Date)
        {

        }
        field(50014; "Application No."; Code[100])
        {

        }
        field(50015; "Product Type"; Code[100])
        {

        }
        field(50016; "Requested Amount"; Decimal)
        {

        }
        field(50017; "Amount"; Decimal)
        {

        }
        field(50018; "Interest"; Decimal)
        {

        }
        field(50019; "Issued Date"; Date)
        {

        }
        field(50020; "Installment"; Integer)
        {

        }
        field(50021; "Repayment"; Decimal)
        {

        }
        field(50022; "Repayement Start Date"; Date)
        {

        }
        field(50023; "Account Found"; Boolean)
        {

        }
        field(50024; "Product Type Found"; Boolean)
        {

        }
        field(50025; "Outstanding Bal"; Decimal)
        {

        }
        field(50026; "Outstanding Interest"; Decimal)
        {

        }
        field(50027; "Client Code"; Code[100])
        {

        }
        field(50028; "Disbursment Acc"; Code[100])
        {

        }
        field(50029; "Shares Capital"; Decimal)
        {

        }
        field(50030; "Shares Deposits"; Decimal)
        {

        }
        field(50031; "Posted"; Boolean)
        {

        }
        field(50032; "Status"; Enum "MemberStatus")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50033; "Selfguarant"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Self Guaranteed';
            Editable = false;
        }
        field(50034; "Idemnity"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50035; "Introduced by"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50036; "Old Account No."; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50037; "Interest Method"; Enum "InterestCalculationMethod")
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50038; "Reversed"; Boolean)
        {

        }
        field(50039; "Source"; Code[100])
        {

        }
        field(50040; "Fee"; Decimal)
        {

        }
        field(50041; "Interest Amount"; Decimal)
        {

        }
        field(50042; "Principal Amount"; Decimal)
        {

        }
        field(50043; "Expected end Date"; Date)
        {

        }
        field(50044; "New Product Code"; Code[100])
        {

        }

    }
    keys
    {
        key("PK"; "No.", "Entry No.")
        {
            Clustered = true;
        }
    }
}



