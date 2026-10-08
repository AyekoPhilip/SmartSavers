table 50312 "File Allocation"
{
    Caption = 'File Allocation';
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "No."; Code[50])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        
            trigger OnValidate()
            begin
                
            end;
        }
        field(50010; "Application No."; Code[50])
        {
            Caption = 'Application No.';
            DataClassification = ToBeClassified;
        }
        field(50011; "ID No."; Code[20])
        {
            Caption = 'ID No.';
            DataClassification = ToBeClassified;
        }
        field(50012; "No. Series"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Application Date"; DateTime)
        {

        }
        field(50014; "Created By"; Code[100])
        {

        }
        field(50015; "Account Name"; Text[150])
        {

        }

    }
    keys
    {
        key("PK"; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SeriesSetup.Get;
            SeriesSetup.TestField(SeriesSetup."File Allocation Nos.");
            
        end;

        "Application Date" := CurrentDateTime;
        "Created By" := UserId;

    end;

    var
        SeriesSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit "No. Series";
        Temp: Record "User Setup";
        RegMngt: Codeunit "Register Management";
        Varvariant: Variant;
}



