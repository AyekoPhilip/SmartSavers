table 50322 "Dsc Mobile Application"
{
    Caption = 'DSC Mobile Application';
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "No."; Code[50])
        {
            Caption = 'No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50010; "Date Entered"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50011; "Time Entered"; Time)
        {
            DataClassification = CustomerContent;
        }
        field(50012; "Entered By"; Code[30])
        {
            DataClassification = CustomerContent;
        }
        field(50013; "Document Serial No"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(50014; "Document Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50015; "Customer ID No"; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50016; "Customer Name"; Text[200])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50017; "Mobile Phone No."; Text[50])
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                AttachApplicationNo();
                fnValidateIdentityMask();
            end;
        }
        field(50018; "Mobile Corporate No."; Code[30])
        {
            DataClassification = CustomerContent;
        }
        field(50019; "Approval Status"; Enum "ApprovalStatus")
        {
            DataClassification = CustomerContent;
            Editable = false;
        
            trigger OnValidate()
            begin
                if "Approval Status" = "Approval Status"::Approved then begin
                    if SavingsAcc.Get(Rec."Application No") then begin
                        MobileNo := SavingsAcc."Mobile No.";
                        SendSMS.CreateSmsNotif(
                SourceType::Other, MobileNo, 'Dear ' + Rec."Customer Name" +
                'Your mobile banking application has been successfully processed. Dial ***** to access. ' +
                CompanyName + '.', Rec."Customer ID No", Rec."Application No", false);
                    end;
                end;
            end;
        }
        field(50020; "Comments"; Text[200])
        {
            DataClassification = CustomerContent;
        }

        field(50021; "Sent To Server"; Option)
        {
            OptionMembers = "No","Yes";
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50022; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }

        field(50023; "Application Type"; Option)
        {
            OptionCaption = 'Initial,Change,Deactivate,Account Onboarding';
            OptionMembers = "Initial","Change","Deactivate","Account Onboarding";
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50024; "Application No"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Account No.';
            TableRelation = "Account Banking" where("Account Category" = const(Savings), "Loan Disbursement Account" = filter(true));
        
            trigger OnValidate()
            begin
                if AccBanking.Get("Application No") then begin
                    "Customer ID No" := AccBanking."ID/Passport No.";
                    "Customer Name" := AccBanking.Name;
                    "Member No." := AccBanking."Member No.";
                    "Mobile Phone No." := AccBanking."Mobile No.";
                end;
            end;
        }
        field(50025; "Changed"; Option)
        {
            OptionCaption = 'No,Yes';
            OptionMembers = "No","Yes";
            DataClassification = CustomerContent;
        }
        field(50026; "I agree information is true"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50027; "Responsibility Center"; Code[10])
        {
            Editable = false;
            TableRelation = "Responsibility Center";
            Caption = 'Responsibility Center';
            DataClassification = CustomerContent;
        }
        field(50028; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50029; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(50030; "Member No."; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Member;
        }
        field(50031; "Transaction Type"; Code[20])
        {
            TableRelation = "Transaction Types".Code where(Type = filter("ATM Applications" | "ATM Applications"));
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
            end;
        }
        field(50032; "Date Posted"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Posted';
        }
        field(50033; "Posted By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup"."User ID";
            Caption = 'Posted By';
        }
        field(50034; "Document Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Mobile Registration","Internet Banking";
        }
    }

    keys
    {
        key("PK"; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin

        TestField("Approval Status", "Approval Status"::Open);
    end;

    trigger OnInsert()
    begin

        if "No." = '' then begin
            NoSetup.GET;
            NoSetup.TESTFIELD(NoSetup."Mobile Application Nos");
            
        end;
        Temp.Get(UserId);
        Temp.TestField("Global Dimension 1 Code");
        Temp.TestField("Global Dimension 2 Code");
        Temp.TestField("Responsibility Centre");
        "Entered By" := USERID;
        "Date Entered" := TODAY;
        "Time Entered" := TIME;
        "Document Date" := Today;
        "Shortcut Dimension 1 Code" := Temp."Global Dimension 1 Code";
        "Shortcut Dimension 2 Code" := Temp."Global Dimension 2 Code";
        "Responsibility Center" := Temp."Responsibility Centre";
    end;

    procedure AttachApplicationNo()
    var
        LoansApp: Record "Dsc Mobile Application";
        CRMLoanApplication: Record "CRM Application";
        Err002: Label 'Mobile No. is already attached to Account No. %1';
    begin
        LoansApp.Reset;
        LoansApp.SetRange("Mobile Phone No.", Rec."Mobile Phone No.");
        if LoansApp.Find('-') then begin
            if Rec."Mobile Phone No." <> '' then
                if LoansApp."No." <> "No." then
                    Error(Err002, LoansApp."Customer Name");
        end;
        Rec."Mobile Phone No." := DelChr(Rec."Mobile Phone No.", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|-|_');
    end;

    procedure fnValidateIdentityMask()
    var
        AccT: Record "Account Banking";
        MemberExistError: label 'This mobile No. already attached to Account %1-%2';
    begin
        if Rec."Mobile Phone No." <> '' then begin

            AccT.Reset;
            AccT.SetRange("Mobile No.", Rec."Mobile Phone No.");
            if AccT.FindFirst then begin
                if AccT."No." <> Rec."Application No" then
                    Message('%1 | %2 | %3', MemberExistError, AccT."ATM No.", AccT.Name);
            end;
        end;
    end;

    procedure PostApprovalOnDocument(Steps: Integer)
    var
        ApprovalMngt: Codeunit "Approval Mgmt.";
    begin
        case Steps of
            1:
                begin
                    TestField("Mobile Phone No.");
                    TestField("Application No");
                    if "Document Type" = "Document Type"::" " then
                        Error('Document Type must have a value. It cannot be blank');
                    ApprovalMngt.OnSendMobileRegtRequest(Rec);
                end;
            2:
                if ApprovalMngt.OnCancelMobileRegtApprovalRequest(Rec, true, true) then;
            3:
                if ApprovalMngt.OpenMobileRegtApprovalRequest(Rec, true, true) then;
            4:
                ApprovalMngt.OpenApprovalEntriesPage(Rec."No.", 52146751);
        end;

    end;

    var
        NoSetup: Record "Banking No. Setup";
        NoSeriesMgt: Codeunit "No. Series";
        MPESAApp: Record "Dsc Mobile Application";
        Temp: Record "User Setup";
        AccBanking: Record "Account Banking";
        SendSMS: Codeunit "SMS Notification";
        SourceType: Enum NotifSourceType;
        SavingsAcc: Record "Account Banking";
        MobileNo: Code[20];
        Cust: Record "Account Banking";


}



