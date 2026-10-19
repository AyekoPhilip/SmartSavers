report 50292 "Fixed Asset"
{
    ApplicationArea = All;
    Caption = 'Fixed Asset ';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/FixedAssetList.Rdl.rdl';


    dataset
    {
        dataitem(FixedAsset; "Fixed Asset")
        {
            column(No; "No.")
            {
            }
            column(Description; Description)
            {
            }
            column(FAPostingGroup; "FA Posting Group")
            {
            }
            column(FAClassCode; "FA Class Code")
            {
            }
            column(FASubclassCode; "FA Subclass Code")
            {
            }
            column(Acquired; Acquired)
            {
            }
            column(Disposed; Disposed)
            {
            }
            column(BookValue; BookValue)
            {

            }

            trigger OnAfterGetRecord()
            begin
                DeprBook.Reset();
                DeprBook.SetRange("FA No.", "No.");
                if DeprBook.FindFirst() then begin
                    DeprBook.CalcFields("Book Value");
                    BookValue := DeprBook."Book Value";
                end;
            end;
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
    var
        DeprBook: Record "FA Depreciation Book";
        BookValue: Decimal;


}



