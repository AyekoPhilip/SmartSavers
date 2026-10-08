namespace SaccoDatabase.SaccoDatabase;
using Microsoft.Foundation.Company;
using DynamicsNav.SaccoDatabase;
using System.IO;
using System.Utilities;

report 90020 "Share Loan Listing"
{
    ApplicationArea = All;
    Caption = 'Shares Loans Listing';
    UsageCategory = Administration;
    ProcessingOnly = true;
    dataset
    {

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(ShowAll; ShowAll)
                    {
                        Caption = 'Show All';
                        ApplicationArea = All;

                    }
                    field(ProdDimension; ProdDimension)
                    {
                        Caption = 'Product Dimension';
                        Enabled = ShowAll = false;
                        ApplicationArea = All;

                    }
                    field(StartDate; StartDate)
                    {
                        Caption = 'Start Date';
                        ApplicationArea = All;

                    }
                    field(EndDate; EndDate)
                    {
                        Caption = 'End Date';
                        ApplicationArea = All;

                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
        trigger OnOpenPage()
        begin

        end;
    }
    labels
    {

    }
    trigger OnInitReport()
    begin

    end;

    trigger OnPostReport()
    begin

    end;

    trigger OnPreReport()
    begin
        if StartDate = 0D then StartDate := 20240101D;
        if EndDate = 0D then EndDate := Today;
        CreateExcelTemp.GenerateCustTemplate(StartDate, EndDate, ProdDimension,ShowAll)
    end;


    var

        nums: Integer;
        CreateExcelTemp: Codeunit "Create Excel Temp. Mgt";
        StartDate: Date;
        EndDate: Date;
        ProdDimension: Enum ProductDimension;
        ShowAll: Boolean;


}
