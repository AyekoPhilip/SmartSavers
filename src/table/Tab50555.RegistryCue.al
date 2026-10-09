table 50555 "Registry Cue"
{
    Caption = 'Finance Cue';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(50010; "Overdue Documents"; Integer)
        {
            CalcFormula = Count("Member Application" WHERE("Approval Status" = CONST(Approved)));
            FieldClass = FlowField;
            Caption = 'Overdue Documents';
        }
        field(50011; "Approved Documents"; Integer)
        {
            CalcFormula = Count("Member Application" WHERE("Approval Status" = CONST(Approved)));
            FieldClass = FlowField;
            Caption = 'Approved Documents';
        }
        field(50012; "Member Pending Approval"; Integer)
        {
            CalcFormula = Count("Member Application" WHERE("Approval Status" = CONST("Pending Approval")));
            FieldClass = FlowField;
            Caption = 'Member Pending Approval';
        }
        field(50013; "Application Pending Approval"; Integer)
        {
            CalcFormula = Count("Account Application" WHERE("Approval Status" = CONST("Pending Approval")));
            FieldClass = FlowField;
            Caption = 'Application Pending Approval';
        }
        field(50014; "Changes Approved"; Integer)
        {
            CalcFormula = Count("Member Changes" WHERE("Approval Status" = CONST(Approved)));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Changes Approved';
        }
        field(50015; "Changes Pending"; Integer)
        {
            CalcFormula = Count("Member Changes" WHERE("Approval Status" = CONST("Pending Approval")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Changes Pending';
        }
        field(50016; "Active Members"; Integer)
        {
            CalcFormula = Count(Member WHERE(Status = CONST(Active)));
            FieldClass = FlowField;
            Caption = 'Active Members';
        }
        field(50017; "Dormant Members"; Integer)
        {
            CalcFormula = Count(Member WHERE(Status = CONST(Dormant)));
            FieldClass = FlowField;
            Caption = 'Dormant Members';
        }
        field(50018; "New Members"; Integer)
        {
            CalcFormula = Count(Member WHERE(Status = CONST(New)));
            FieldClass = FlowField;
            Caption = 'New Members';
        }
        field(50019; "Active Accounts"; Integer)
        {
            CalcFormula = Count("Account Credit" WHERE(Status = CONST(Active)));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Active Accounts';
        }
        field(50020; "Dormant Accounts"; Integer)
        {
            CalcFormula = Count("Account Credit" WHERE(Status = CONST(Dormant)));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Dormant Accounts';
        }
        field(50021; "Application Approved"; Integer)
        {
            CalcFormula = Count("Account Application" WHERE("Approval Status" = CONST(Approved)));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Application Approved';
        }
        field(50022; "Application Pending"; Integer)
        {
            CalcFormula = Count("Account Application" WHERE("Approval Status" = CONST("Pending Approval")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Application Pending';
        }
        field(50023; "Due Next Week Filter"; Date)
        {
            Caption = 'Due Next Week Filter';
            FieldClass = FlowFilter;
        }
        field(50024; "Due Date Filter"; Date)
        {
            Caption = 'Due Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(50025; "Overdue Date Filter"; Date)
        {
            Caption = 'Overdue Date Filter';
            FieldClass = FlowFilter;
        }
        field(50026; "New Incoming Documents"; Integer)
        {
            Caption = 'New Incoming Documents';
            FieldClass = Normal;
            DataClassification = CustomerContent;
        }
        field(50027; "Approved Incoming Documents"; Integer)
        {
            Caption = 'Approved Incoming Documents';
            FieldClass = Normal;
            DataClassification = CustomerContent;
        }
        field(50028; "OCR Pending"; Integer)
        {
            Caption = 'OCR Pending';
            FieldClass = Normal;
            DataClassification = CustomerContent;
        }
        field(50029; "OCR Completed"; Integer)
        {
            Caption = 'OCR Completed';
            FieldClass = Normal;
            DataClassification = CustomerContent;
        }
        field(50030; "Requests to Approve"; Integer)
        {
            CalcFormula = Count("Approval Entry" WHERE("Approver ID" = FIELD("User ID Filter"),
                                                        Status = FILTER(Open)));
            Caption = 'Workflows for Approval';
            FieldClass = FlowField;
        }
        field(50031; "Requests Sent for Approval"; Integer)
        {
            CalcFormula = Count("Approval Entry" WHERE("Sender ID" = FIELD("User ID Filter"),
                                                        Status = FILTER(Open)));
            Caption = 'Requests Sent for Approval';
            FieldClass = FlowField;
        }
        field(50032; "User ID Filter"; Code[50])
        {
            Caption = 'User ID Filter';
            FieldClass = FlowFilter;
        }
        field(50033; "Non-Applied Payments"; Integer)
        {
            Caption = 'Non-Applied Payments';
            FieldClass = Normal;
            DataClassification = CustomerContent;
        }
        field(50034; "Cash Accounts Balance"; Decimal)
        {
            AutoFormatExpression = GetAmountFormat;
            AutoFormatType = 10;
            Caption = 'Cash Accounts Balance';
            FieldClass = Normal;
            DataClassification = CustomerContent;
        }
        field(50035; "Last Depreciated Posted Date"; Date)
        {
            Caption = 'Last Depreciated Posted Date';
            FieldClass = Normal;
            DataClassification = CustomerContent;
        }
        field(50036; "Outstanding Vendor Invoices"; Integer)
        {
            Caption = 'Outstanding Vendor Invoices';
            Editable = false;
            FieldClass = Normal;
            DataClassification = CustomerContent;
        }
        field(50037; "Request to Approve"; Integer)
        {
            CalcFormula = Count("Approval Entries" where("Approver ID" = field("User ID Filter"), Status = filter(Open)));
            Caption = 'Requests to Approve';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key("Key1"; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    local procedure GetAmountFormat(): Text
    var
        ActivitiesCue: Record "Activities Cue";
    begin
        exit(ActivitiesCue.GetAmountFormat);
    end;
}




