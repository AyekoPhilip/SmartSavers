namespace SaccoDatabase.SaccoDatabase;

xmlport 50001 "Import CheckOff- Product"
{
    Caption = 'Import CheckOff- Product';
    Direction = Import;
    Format = VariableText;
    FormatEvaluate = Legacy;
    TextEncoding = WINDOWS;

    schema
    {
        textelement(RootNodeName)
        {
            tableelement(CheckoffReceiptLines; "Checkoff Receipt Lines")
            {
                XmlName = 'PayrollCheckoff';
                fieldelement(No; CheckoffReceiptLines."No.")
                {
                }
                fieldelement(EmployerCode; CheckoffReceiptLines."Employer Code")
                {
                }
                fieldelement(UploadID; CheckoffReceiptLines."Upload ID")
                {
                    FieldValidate = yes;
                }
                fieldelement(ProductType; CheckoffReceiptLines."Product Type")
                {
                }
                fieldelement(Amount; CheckoffReceiptLines.Amount)
                {
                    FieldValidate = yes;
                }
                trigger OnAfterInitRecord()
                begin
                    CheckoffReceiptLines."Upload Response" := Response;
                end;
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
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
