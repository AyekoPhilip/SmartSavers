table 50275 "Delegate User Profile"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
        
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    CashManagementSetup.Get();
                    
                    "No Series" := '';
                end;
            end;
        }
        field(50010; "Date Created"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Created';
        }
        field(50011; "Time Created"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Time Created';
        }
        field(50012; "User ID"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "User Setup"."User ID";
            Caption = 'User ID';
        
            trigger OnValidate()
            begin
                if "User ID" <> '' then begin
                    UserPersonalization.Reset();
                    UserPersonalization.SetRange(UserPersonalization."User ID", "User ID");
                    if UserPersonalization.FindFirst() then begin
                        "Current Profile" := UserPersonalization."Profile ID";
                        Company := UserPersonalization.Company;
                    end else
                        Error('User personalization does not exist for %1', "User ID");
                end;
            end;
        }
        field(50013; "Current Profile"; Code[100])
        {
            DataClassification = CustomerContent;
            TableRelation = "All Profile"."Profile ID";
            Caption = 'Current Profile';
        }
        field(50014; "New Profile"; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'New Profile';
        }
        field(50015; "Company"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Company.Name;
            Caption = 'Company';
        }
        field(50016; "New Company"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Company.Name;
            Caption = 'New Company';
        }
        field(50017; "Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'New,Assigned';
            OptionMembers = "New","Assigned";
            Caption = 'Status';
        }
        field(50018; "Assigned By"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Assigned By';
        }
        field(50019; "No Series"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No Series';
        }
        field(50020; "Assigned Date"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Assigned Date';
        }
        field(50021; "From"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'From';
        }
        field(50022; "To Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'To Date';
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
            CashManagementSetup.Get();
            CashManagementSetup.TestField("Profile Delegation Nos");
            
        end;

        "Date Created" := Today;
        "Time Created" := Time;
        From := Today;
    end;

    var
        CashManagementSetup: Record "Cash Management Setups";
        UserPersonalization: Record "User Personalization";
        NoSeriesManagement: Codeunit "No. Series";

    procedure Delegate()
    var
        Personalization: Record "User Personalization";
    begin
        TestField("New Profile");

        Personalization.Reset();
        Personalization.SetRange(Personalization."User ID", "User ID");
        if Personalization.FindFirst() then begin
            Personalization."Profile ID" := "New Profile";
            if "New Company" <> '' then
                Personalization.Company := "New Company";
            Personalization.Modify();
            Commit();
            Status := Status::Assigned;
            "Assigned By" := UserId;
            "Assigned Date" := CreateDateTime(Today, Time);
        end;
    end;
}


