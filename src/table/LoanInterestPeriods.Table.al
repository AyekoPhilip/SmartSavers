table 50271 "Loan Interest Periods"
{

    Caption = 'Interest Period';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Period Month"; Integer)
        {
            Caption = 'Period Month';
            Editable = false;
        }
        field(50010; "Period Year"; Integer)
        {
            Caption = 'Period Year';
            Editable = false;
        }
        field(50011; "Period Name"; Text[100])
        {
            Caption = 'Period Name';
            Editable = false;
        }
        field(50012; "Date Closed"; Date)
        {
            Caption = 'Date Closed';
            Editable = false;
        }
        field(50013; "Date Opened"; Date)
        {
            Caption = 'Date Opened';
            Editable = false;
        }
        field(50014; "Closed"; Boolean)
        {
            Caption = 'Closed';
            Editable = false;
        }
        field(50015; "Created By"; Code[100])
        {
            Caption = 'Created By';
            Editable = false;
        }
        field(50016; "Posted By"; Code[100])
        {
            Caption = 'Posted By';
            Editable = false;
        }
        field(50017; "Payroll Code"; Code[50])
        {

        }
    }
    keys
    {
        key("PK"; "Date Opened")
        {
            Clustered = true;
        }
    }
    procedure fnGetOpenPeriod(): Date
    var
    begin
        PayPeriod.SetRange(Closed, true);
        if PayPeriod.FindFirst() then begin
            dtOpenPeriod := PayPeriod."Date Opened";
            exit(dtOpenPeriod)
        end
    end;

    procedure fnCloseInterestPeriod(dtOpenPeriod: Date) Closed: Boolean
    var
        dtNewPeriod: Date;
        intNewMonth: Integer;
        intNewYear: Integer;
        intMonth: Integer;
        intYear: Integer;
        curTransAmount: Decimal;
        curTransBalance: Decimal;
        CreateTrans: Boolean;
    begin

        dtNewPeriod := CalcDate('1M', dtOpenPeriod);
        intNewMonth := Date2DMY(dtNewPeriod, 2);
        intNewYear := Date2DMY(dtNewPeriod, 3);

        intMonth := Date2DMY(dtOpenPeriod, 2);
        intYear := Date2DMY(dtOpenPeriod, 3)
    end;

    var
        PayPeriod: Record "Pr Payroll Period";
        dtOpenPeriod: Date;
        DocPostMngt: Codeunit "Doc-PostMgt";
}
