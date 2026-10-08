table 50434 "Bankers Cheque Application"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
               
            end;
        }
        field(50010; "Application Date"; Date)
        {
            Caption = 'Application Date';
            DataClassification = CustomerContent;
        }
        field(50011; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(50012; "Responsibility Centre"; Code[10])
        {
            TableRelation = "Responsibility Center BR";
            Caption = 'Responsibility Centre';
            DataClassification = CustomerContent;
        }
        field(50013; "Begining Cheque No."; Code[6])
        {
            Caption = 'Begining Cheque No.';
            DataClassification = CustomerContent;
        }
        field(50014; "Cheque Register Generated"; Boolean)
        {
            Editable = false;
            Caption = 'Cheque Register Generated';
            DataClassification = CustomerContent;
        }
        field(50015; "Approval Status"; Option)
        {
            OptionCaption = 'Open,Pending Approval,Approved,Rejected';
            OptionMembers = "Open","Pending Approval","Approved","Rejected";
            Caption = 'Status';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50016; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50017; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(50018; "No of Leaves"; Integer)
        {
            Caption = 'No of Leaves';
            DataClassification = CustomerContent;
        }
        field(50019; "Bank Account"; Code[20])
        {
            TableRelation = "Bank Account";
            Caption = 'Bank Account';
            DataClassification = CustomerContent;
        }
        field(50020; "Leaf Limit Amount"; Decimal)
        {
            Caption = 'Leaf Limit Amount';
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
            SalesSetup.Get;
            SalesSetup.TestField(SalesSetup."Bankers Cheque Application Nos");
        end;



        "Application Date" := Today;

        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."User ID", UserId);
        if UserSetup.Find('-') then begin
            UserSetup.TestField(UserSetup."Global Dimension 1 Code");
            UserSetup.TestField(UserSetup."Global Dimension 2 Code");

            "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
            "Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
            "Responsibility Centre" := UserSetup."Responsibility Centre";
        end;
    end;

    trigger OnModify()
    begin

        if "Approval Status" = "Approval Status"::Approved then begin
            if "Cheque Register Generated" = true then
                Error('Cheque register has already been generated.');
        end;
    end;

    var
        Noseriesmgt: Codeunit "No. Series";
        SalesSetup: Record "Banking No. Setup";
        UserSetup: Record "User Setup";
}




