report 50378 "Export Mediaset"
{
    ApplicationArea = All;
    Caption = 'Export Mediaset';
    UsageCategory = Administration;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;

    dataset
    {
        dataitem(Member; "Temp Data")
        {
            column(No; "No.")
            {
            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                ExportImage();
            end;

            trigger OnPostDataItem()
            begin
                Message('Items processed ' + Format(ItemCnt) + ' Pictures processed ' + Format(PicCount));
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(MediaFileToExport; MediaFileToExport)
                    {
                        Caption = 'Media Options';
                        ApplicationArea = All;
                    }
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
    procedure ExportImage()
    var
        MyItem: Record "Image Data";
        Item: Record Item;
        TenantMedia: Record "Tenant Media";
        datacompresion: Codeunit 425;
        blobStorage: Codeunit "Temp Blob";
        PicInStream, ZipInStream : InStream;
        ZipOutStream: OutStream;
        ZipFileName: Text;

    begin
        ZipFileName := 'Mediaset.zip';
        datacompresion.CreateZipArchive();
        MyItem.Reset();
        MyItem.FindSet();
        repeat

            ItemCnt := ItemCnt + 1;
            PicCount := PicCount + 1;

            case MediaFileToExport of
                MediaFileToExport::" ":
                    begin
                        Error('Invalid OPtion');
                    end;

                MediaFileToExport::Picture:
                    begin
                        if MyItem.Picture.HasValue then begin
                            if TenantMedia.Get(MyItem.Picture.MediaId()) then begin
                                TenantMedia.calcfields(Content);
                                if TenantMedia.Content.HasValue then begin
                                    TenantMedia.Content.CreateInStream(PicInstream);
                                    datacompresion.AddEntry(PicInStream, MyItem."Member No." + '.Jpg');
                                end;
                            end;
                        end;
                    end;
                MediaFileToExport::Signature:
                    begin
                        if MyItem.Signature.HasValue then begin
                            if TenantMedia.Get(MyItem.Signature.MediaId()) then begin
                                TenantMedia.calcfields(Content);
                                if TenantMedia.Content.HasValue then begin
                                    TenantMedia.Content.CreateInStream(PicInstream);
                                    datacompresion.AddEntry(PicInStream, MyItem."Member No." + '.Jpg');
                                end;
                            end;
                        end
                    end;
            end
        until MyItem.Next() = 0;

        blobStorage.CreateOutStream(ZipOutStream);
        datacompresion.SaveZipArchive(ZipOutStream);
        datacompresion.CloseZipArchive();
        blobStorage.CreateInStream(ZipInStream);
        DownloadFromStream(ZipInStream, 'Download zip file', '', '', ZipFileName);

    end;

    var
        ItemCnt, Index, PicCount : Integer;
        MediaFileToExport: Option " ",Picture,Signature;
}



