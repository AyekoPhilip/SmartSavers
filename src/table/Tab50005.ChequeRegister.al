table 50005 "Cheque Register"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Cheque No."; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Cheque No.';
        }
        field(50010; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
            DataClassification = CustomerContent;
            TableRelation = "Bank Account";
        }
        field(50011; "Date Generated"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Generated';
        }
        field(50012; "Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(50013; "Cheque Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Cheque Date';
        }
        field(50014; "Bank Payment Type"; Option)
        {
            Caption = 'Bank Payment Type';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Computer Check,Manual Check,Electronic Payment';
            OptionMembers = " ","Computer Check","Manual Check","Electronic Payment";
        }
        field(50015; "Entry Status"; Option)
        {
            Caption = 'Entry Status';
            DataClassification = CustomerContent;
            OptionCaption = ',Printed,Voided,Posted,Financially Voided,Test Print,Exported,Transmitted,Issued,Cancelled';
            OptionMembers = "","Printed","Voided","Posted","Financially Voided","Test Print","Exported","Transmitted","Issued","Cancelled";
        }
        field(50016; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
            TableRelation = User."User Name";
        
            trigger OnLookup()
            begin
                //UserMgt.LookupUserID("User ID");
            end;
        }
        field(50017; "Issued By"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Issued By';
        }
        field(50018; "Posted By"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Posted By';
        }
        field(50019; "Issued Doc No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Issued Doc No.';
        }
        field(50020; "Issued"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Issued';
        }
        field(50021; "Voided"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Voided';
        }
        field(50022; "Voided By"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Voided By';
        }
        field(50023; "Void Date-Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Void Date-Time';
        }
        field(50024; "Cancelled"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Cancelled';
        }
        field(50025; "Cancelled By"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Cancelled By';
        }
        field(50026; "Cancelled Date-Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Cancelled Date-Time';
        }
    }

    keys
    {
        key("Key1"; "Cheque No.", "Bank Account No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


