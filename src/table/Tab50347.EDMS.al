table 50347 "EDMS"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "url path"; Text[200])
        {
            Caption = 'url path';
            DataClassification = CustomerContent;
        }
        field(50010; "Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50011; "Key"; Option)
        {
            OptionMembers = " ","Member File","Invoice","Delivery Note","Evaluation Report","Proc File","Employee File","Loan File","member App","Board Minutes","Interview Results","Award Letter","Contract","Loan App","Online Loans";
            Caption = 'Key';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "url path")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




