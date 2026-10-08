page 50446 "CRB Data Sheet"
{
    ApplicationArea = All;
    Caption = 'CRB Data Sheet';
    PageType = List;
    SourceTable = "CRB Data";
    UsageCategory = Lists;
    Editable = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Surname; Rec.Surname)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Surname field.';
                }
                field("Forename 1"; Rec."Forename 1")
                {
                    ApplicationArea = All;

                }
                field("Forename 2"; Rec."Forename 2")
                {
                    ApplicationArea = All;

                }
                field("Forename 3"; Rec."Forename 3")
                {
                    ApplicationArea = All;

                }
                field("Trading As"; Rec."Trading As")
                {
                    ApplicationArea = All;

                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ApplicationArea = All;
                }
                field("Client Code"; Rec."Client Code")
                {
                    ApplicationArea = All;

                }
                field("Loan No."; Rec."Account Number")
                {
                    ApplicationArea = All;
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gender field.';
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = All;
                }
                field("Primary Identification code"; Rec."Primary Identification code")
                {
                    ApplicationArea = All;

                }
                field("Primary Identification Number"; Rec."Primary Identification Number")
                {
                    ApplicationArea = All;
                }
                field("Secondary Identification"; Rec."Secondary Identification")
                {
                    ApplicationArea = All;
                }
                field("Secondary Identification code"; Rec."Secondary Identification code")
                {
                    ApplicationArea = All;
                }
                field("Other Identification Type"; Rec."Other Identification Type")
                {
                    ApplicationArea = All;
                }
                field("Other Identification Number"; Rec."Other Identification Number")
                {
                    ApplicationArea = All;
                }
                field("Passoprt Country Code"; Rec."Passoprt Country Code")
                {
                    ApplicationArea = All;

                }
                field("Mobile No"; Rec."Mobile No")
                {
                    ApplicationArea = All;
                }
                field("Home Telephone"; Rec."Home Telephone")
                {
                    ApplicationArea = All;

                }
                field("Work Telephone"; Rec."Work Telephone")
                {
                    ApplicationArea = All;
                }
                field("Postal Address 1"; Rec."Postal Address 1")
                {
                    ApplicationArea = All;
                }
                field("Postal Address 2"; Rec."Postal Address 2")
                {
                    ApplicationArea = All;
                }
                field("Postal Location Town"; Rec."Postal Location Town")
                {
                    ApplicationArea = All;
                }
                field("Postal Location Country"; Rec."Postal Location Country")
                {
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;

                }
                field("Physical Address 1"; Rec."Physical Address 1")
                {
                    ApplicationArea = All;

                }
                field("Physical Address 2"; Rec."Physical Address 2")
                {
                    ApplicationArea = All;
                }
                field("Plot Number"; Rec."Plot Number")
                {
                    ApplicationArea = All;
                }
                field("Location Town"; Rec."Location Town")
                {
                    ApplicationArea = All;
                }
                field("Location Country"; Rec."Location Country")
                {
                    ApplicationArea = All;
                }
                field("Type of Residence"; Rec."Type of Residence")
                {
                    ApplicationArea = All;


                }
                field("PIN Number"; Rec."PIN Number")
                {
                    ApplicationArea = All;
                }
                field("Customer Work Email"; Rec."Customer Work Email")
                {
                    ApplicationArea = All;
                }
                field("Employer Name"; Rec."Employer Name")
                {
                    ApplicationArea = All;
                }
                field("Occupational Industry Type"; Rec."Occupational Industry Type")
                {
                    ApplicationArea = All;
                }
                field("Employment Date"; Rec."Employment Date")
                {
                    ApplicationArea = All;

                }
                field("Employment Type"; Rec."Employment Type")
                {
                    ApplicationArea = All;
                }
                field("Income Amount "; Rec."Income Amount")
                {
                    ApplicationArea = All;

                }
                field("Lenders Registered Name"; Rec."Lenders Registered Name")
                {
                    ApplicationArea = All;

                }
                field("Lenders Trading Name"; Rec."Lenders Trading Name")
                {
                    ApplicationArea = All;
                }
                field("Lenders Branch Name"; Rec."Lenders Branch Name")
                {

                }
                field("Lenders Branch Code"; Rec."Lenders Branch Code")
                {
                    ApplicationArea = All;

                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;

                }
                field("Account Product Type"; Rec."Account Product Type")
                {
                    ApplicationArea = All;
                }
                field("Date Account Opened"; Rec."Date Account Opened")
                {

                }
                field("Installment Due Date"; Rec."Installment Due Date")
                {
                    ApplicationArea = All;

                }
                field("Original Amount"; Rec."Original Amount")
                {
                    ApplicationArea = All;
                }
                field("Currency of Facility"; Rec."Currency of Facility")
                {
                    ApplicationArea = All;
                }
                field("Current Balance"; Rec."Current Balance")
                {
                    ApplicationArea = All;
                }
                field("Overdue Balance"; Rec."Overdue Balance")
                {
                    ApplicationArea = All;
                }
                field("Overdue Date"; Rec."Overdue Date")
                {
                    ApplicationArea = All;
                }
                field("No of Days in Arreas"; Rec."No of Days in Arreas")
                {
                    ApplicationArea = All;
                }
                field("No of Installment In"; Rec."No of Installment In")
                {
                    ApplicationArea = All;
                }
                field("Prudential Risk Classification"; Rec."Prudential Risk Classification")
                {
                    ApplicationArea = All;

                }
                field("Account Status"; Rec."Account Status")
                {
                    ApplicationArea = All;
                }
                field("Account Closure Reason"; Rec."Account Closure Reason")
                {
                    ApplicationArea = All;
                }
                field("Repayment Period"; Rec."Repayment Period")
                {
                    ApplicationArea = All;
                }
                field("Deferred Payment Date"; Rec."Deferred Payment Date")
                {
                    ApplicationArea = All;
                }
                field("Deferred Payment"; Rec."Deferred Payment")
                {
                    ApplicationArea = All;
                }
                field("Payment Frequency"; Rec."Payment Frequency")
                {
                    ApplicationArea = All;
                }
                field("Disbursement Date"; Rec."Disbursement Date")
                {
                    ApplicationArea = All;

                }
                field("Insallment Amount"; Rec."Insallment Amount")
                {
                    ApplicationArea = All;

                }
                field("Date of Latest Payment"; Rec."Date of Latest Payment")
                {
                    ApplicationArea = All;
                }
                field("Last Payment Amount"; Rec."Last Payment Amount")
                {
                    ApplicationArea = All;
                }
                field("Type of Security"; Rec."Type of Security")

                {
                    ApplicationArea = All;
                }








            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Generate CRB Data")
            {
                Image = Relatives;
                ApplicationArea = All;
                trigger OnAction()
                var
                begin
                    Report.Run(Report::"Generate CRB Data");
                end;
            }
            action(GenerateCRBFile)
            {
                Image = Excel;
                Caption = 'Create Excel File';
                ApplicationArea = All;
                trigger OnAction()
                var
                    TempFile: File;
                    Name: Text[250];
                    NewStream: InStream;
                    ToFile: Text[250];
                    ReturnValue: Boolean;
                    TempBlob: Codeunit "Temp Blob";
                    OutS: OutStream;
                    GenerateCRBData: Report "Generate CRB Data";
                begin
                    //Old Code
                    /* TempFile.TextMode(False);
                    TempFile.WriteMode(True);
                    Name := 'C:\Temps\';
                    TempFile.Create(Name);
                    TempFile.Close;
                    Report.SaveAsExcel(Report::"Generate CRB Data", Name);
                    TempFile.Open(Name);
                    TempFile.CreateInStream(NewStream);
                    ToFile := 'Report.xls';
                    ReturnValue := DownloadFromStream(
                    NewStream, 'Save file to client',
                    '', 'Excel File *.xls| *.xls',
                    ToFile);
                    TempFile.Close(); */

                    //New Cloud Friendly Code
                    TempBlob.CreateOutStream(OutS);
                    if GenerateCRBData.SaveAs('', ReportFormat::Excel, OutS) then begin
                        TempBlob.CreateInStream(NewStream);
                        ReturnValue := DownloadFromStream(NewStream, 'Save file to client',
                                                            '', 'Excel File *.xls| *.xls', ToFile);
                    end;
                end;
            }

        }
        area(Promoted)
        {
            group(Category_Report)
            {
                Caption = 'Statement', Comment = 'Generated from the PromotedActionCategories property index 2.';
            }
            group(Category_Category4)
            {
                Caption = 'Activities', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref("Generate CRB Data_Promoted"; "Generate CRB Data")
                {
                }
                actionref(GenerateCRBFile_Promoted; GenerateCRBFile)
                {
                }
            }
            group(Category_Category5)
            {
                Caption = 'Accounts', Comment = 'Generated from the PromotedActionCategories property index 4.';
            }
            group(Category_Category6)
            {
                Caption = 'File', Comment = 'Generated from the PromotedActionCategories property index 5.';
            }
            group(Category_Category7)
            {
                Caption = 'Statistics', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'Dividends', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
            group(Category_Category9)
            {
                Caption = 'Advice', Comment = 'Generated from the PromotedActionCategories property index 8.';
            }
        }

    }
}



