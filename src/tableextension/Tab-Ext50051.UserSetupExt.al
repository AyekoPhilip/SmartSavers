tableextension 50051 "UserSetupExt" extends "User Setup"
{
    fields
    {
        field(50009; "Picture"; Blob)
        {
            DataClassification = CustomerContent;
            SubType = Bitmap;
            Caption = 'Picture';
        }
        field(50010; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "HR Employees";
            Caption = 'Employee No.';
        }
        field(50011; "Immediate Supervisor"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "User Setup"."User ID";
            Caption = 'Immediate Supervisor';
        }
        field(50013; "Signature"; Blob)
        {
            Subtype = Bitmap;
            DataClassification = CustomerContent;
            Caption = 'Signature';
        }
        field(50014; "HOD User"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'HOD User';
        }
        field(50012; "Customer No."; Code[20])
        {
            TableRelation = Customer;
            DataClassification = CustomerContent;
            Caption = 'Customer No.';
        }
        field(50015; "HOD Imprest Approver"; Code[50])
        {
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
            Caption = 'HOD Imprest Approver';
        }
        field(50016; "Show All"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Show All';
        }
        field(50017; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            DataClassification = CustomerContent;
            Caption = 'Global Dimension 1 Code';
        }
        field(50018; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            DataClassification = CustomerContent;
            Caption = 'Global Dimension 2 Code';
        }
        field(50019; "Delegated From"; Code[50])
        {
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
            Caption = 'Delegated From';
        }
        field(50020; "Responsibility Centre"; Code[10])
        {
            AccessByPermission = tabledata "Responsibility Center" = RIMD;
            DataClassification = CustomerContent;
            TableRelation = "Responsibility Center";
            Caption = 'Responsibility Center';
        }
        field(50021; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(50022; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(50023; "Imprest Account"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
            Caption = 'Imprest Account';
        }
        field(50024; "Post Journals"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Post Journals';
        }
        field(50025; "Post Bank Reconcilliation"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Post Bank Reconcilliation';
        }
        field(50026; "Office/Group"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Office/Group".Code;
            Caption = 'Office/Group';
        }
        field(50027; "Allow Posting From [Time]"; Time)
        {
            Caption = 'Allow Posting From [Time]';
            DataClassification = CustomerContent;
        }
        field(50028; "Allow Posting To [Time]"; Time)
        {
            Caption = 'Allow Posting To [Time]';
            DataClassification = CustomerContent;
        }
        field(50029; "Show Hidden"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Show Hidden';
        }
        field(50030; "Reverse Register"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Reverse Register';
        }
        field(50031; "Multiple Login"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Multiple Login';
        }
        field(50032; "Max. No. [Open Documents]"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Max. No. [Open Documents]';
        }
        field(50033; "Post Reversals"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Post Reversals';
        }
        field(50034; "Unlimited PV Amount Approval"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Unlimited PV Amount Approval';
        }
        field(50035; "Unlimited Loan Amt Appr"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Unlimited Loan Amt Appr';
        }
        field(50036; "Loan Amt Approval Limit"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Loan Amt Approval Limit';
        }
        field(50037; "Member No."; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Member No.';
            TableRelation = Member;
        }
        field(50038; "Allow Login After Hours"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50039; "Request Admin"; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(50040; "Approval Status"; Enum "ApprovalStatus")
        {
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(50041; "User Type"; Option)
        {
            DataClassification = SystemMetadata;
            OptionMembers = "Limited to User","View All","Approval Limits";
        }

        field(50042; "Account Type"; Option)
        {
            OptionMembers = "Manual Posting","Automated Posting";
        }
        field(50043; "Account Department"; Enum "ApplicationSource")
        {
            DataClassification = SystemMetadata;
            Caption = 'Office Department';
        }
        field(50044; "PV Amount Approval Limit"; Decimal)
        {
            DataClassification = SystemMetadata;
        }
    }
}


