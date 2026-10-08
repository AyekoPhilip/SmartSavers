xmlport 50021 "Import Checkoff Receipts"
{
    Caption = 'CheckOff Buffer';
    Direction = Import;
    Format = VariableText;
    FormatEvaluate = Legacy;
    TextEncoding = WINDOWS;

    schema
    {
        textelement(Root)
        {
            tableelement("Checkoff Receipt Lines"; "Checkoff Receipt Lines")
            {
                XmlName = 'PayrollBuffer';
                fieldelement(a; "Checkoff Receipt Lines"."No.")
                {
                    FieldValidate = yes;
                }
                fieldelement(c; "Checkoff Receipt Lines"."Employer Code")
                { }
                fieldelement(d; "Checkoff Receipt Lines"."Upload ID")
                {
                    FieldValidate = yes;
                }
                fieldelement(f; "Checkoff Receipt Lines"."Account Category")
                { }
                fieldelement(e; "Checkoff Receipt Lines".Amount)
                { 
                    FieldValidate=Yes;
                }
                fieldelement(h; "Checkoff Receipt Lines"."Interest Repayment")
                { }
                fieldelement(f; "Checkoff Receipt Lines"."Loan No.")
                { }
                trigger OnAfterInitRecord()
                begin
                    "Checkoff Receipt Lines"."Upload Response" := Response;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnInitXmlPort()
    begin
        I := 0;
    end;

    trigger OnPostXmlPort()
    begin
        if Response = 0 then begin
            Receiptline.Reset;
            Receiptline.SetRange("Upload Response", 0);
            Receiptline.DeleteAll
        end else begin
            Message(Text01);
        end
    end;

    trigger OnPreXmlPort()
    begin
        Response := ConfirmPost;
        if Response = 0 then
            exit
    end;

    var
        I: Integer;
        Response: Integer;
        Receiptline: Record "Checkoff Receipt Lines";
        Text01: Label 'Upload done successfully';

    local procedure ConfirmPost(): Integer
    var
        Selection: Integer;
        ShipInvoiceQst: Label '&Member No.,&ID/Passport No.,Payroll No.,&Repayment A/c';
        DefaultOption: Integer;
        PassInt: Integer;
    begin
        if DefaultOption > 4 then
            DefaultOption := 4;
        if DefaultOption <= 0 then
            DefaultOption := 1;
        Selection := StrMenu(ShipInvoiceQst, DefaultOption, 'Please select option to validate lines');
        PassInt := Selection;
        if Selection = 0 then
            exit;
        exit(PassInt);
    end;
}




