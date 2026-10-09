table 50578 "Image Data Buffer"
{
    Caption = 'Image Data Buffer';
    DataClassification = ToBeClassified;
    ReplicateData = false;

    fields
    {
        field(50009; "File Name"; Text[260])
        {
            Caption = 'File Name';
        }
        field(50010; "Picture"; Media)
        {
            Caption = 'Picture';
        }
        field(50011; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(50012; "Item Description"; Text[100])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            Caption = 'Item Description';
            FieldClass = FlowField;
        }
        field(50013; "Import Status"; Option)
        {
            Caption = 'Import Status';
            Editable = false;
            OptionCaption = 'Skip,Pending,Completed';
            OptionMembers = "Skip","Pending","Completed";
        }
        field(50014; "Picture Already Exists"; Boolean)
        {
            Caption = 'Picture Already Exists';
        }
        field(50015; "File Size (KB)"; BigInteger)
        {
            Caption = 'File Size (KB)';
        }
        field(50016; "File Extension"; Text[30])
        {
            Caption = 'File Extension';
        }
        field(50017; "Modified Date"; Date)
        {
            Caption = 'Modified Date';
        }
        field(50018; "Modified Time"; Time)
        {
            Caption = 'Modified Time';
        }
    }

    keys
    {
        key("Key1"; "File Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(Brick; "File Name", "Item No.", "Item Description", Picture)
        {
        }
    }

    var
        SelectZIPFileMsg: Label 'Select ZIP File';

    [Scope('Cloud')]
    procedure LoadZIPFile(ZipFileName: Text; var TotalCount: Integer; ReplaceMode: Boolean): Text
    var
        Item: Record "Image Data";
        FileMgt: Codeunit "File Management";
        DataCompression: Codeunit "Data Compression";
        TempBlob: Codeunit "Temp Blob";
        Window: Dialog;
        EntryList: List of [Text];
        EntryListKey: Text;
        ServerFile: File;
        InStream: InStream;
        EntryOutStream: OutStream;
        EntryInStream: InStream;
        ServerFileOpened: Boolean;
        Length: Integer;
        CustRecord: Record Member;
    begin
        if ZipFileName <> '' then begin
            //ServerFileOpened := ServerFile.Open(ZipFileName);
            //ServerFile.CreateInStream(InStream)
        end else begin
            if not UploadIntoStream(SelectZIPFileMsg, '', 'Zip Files|*.zip', ZipFileName, InStream) then
                Error('');
        end;

        DataCompression.OpenZipArchive(InStream, false);
        DataCompression.GetEntryList(EntryList);

        Window.Open('#1##############################');

        TotalCount := 0;
        DeleteAll();
        foreach EntryListKey in EntryList do begin
            Init;
            "File Name" :=
                CopyStr(FileMgt.GetFileNameWithoutExtension(EntryListKey), 1, MaxStrLen("File Name"));
            "File Extension" :=
                CopyStr(FileMgt.GetExtension(EntryListKey), 1, MaxStrLen("File Extension"));
            TempBlob.CreateOutStream(EntryOutStream);
            //DataCompression.ExtractEntry(EntryListKey, EntryOutStream, Length); Dropped On Version 23
            TempBlob.CreateInStream(EntryInStream);

            if not IsNullGuid(Picture.ImportStream(EntryInStream, FileMgt.GetFileName(EntryListKey))) then begin
                Window.Update(1, "File Name");
                "File Size (KB)" := Length;
                TotalCount += 1;
                if StrLen("File Name") <= MaxStrLen(Item."Old Member No.") then
                    Item.Reset();
                Item.SetRange("Old Member No.", "File Name");
                if Item.FindFirst() then begin
                    "Item No." := Item."Member No.";
                    "Item Description" := Item.Description;
                    if Item."Picture ID".Count > 0 then begin
                        "Picture Already Exists" := true;
                        if ReplaceMode then
                            "Import Status" := "Import Status"::Pending;
                    end else
                        "Import Status" := "Import Status"::Pending;
                end;
                Insert;
            end;
        end;

        DataCompression.CloseZipArchive;
        Window.Close;

        if ServerFileOpened then
            //ServerFile.Close;
        exit(ZipFileName);
    end;

    [Scope('Cloud')]
    procedure LoadZIPFile2(ZipFileName: Text; var TotalCount: Integer; ReplaceMode: Boolean): Text
    var
        Item: Record "Image Data";
        FileMgt: Codeunit "File Management";
        DataCompression: Codeunit "Data Compression";
        TempBlob: Codeunit "Temp Blob";
        Window: Dialog;
        EntryList: List of [Text];
        EntryListKey: Text;
        ServerFile: File;
        InStream: InStream;
        EntryOutStream: OutStream;
        EntryInStream: InStream;
        ServerFileOpened: Boolean;
        Length: Integer;
        CustRecord: Record Member;
    begin
        if ZipFileName <> '' then begin
            //ServerFileOpened := ServerFile.Open(ZipFileName);
            //ServerFile.CreateInStream(InStream)
        end else begin
            if not UploadIntoStream(SelectZIPFileMsg, '', 'Zip Files|*.zip', ZipFileName, InStream) then
                Error('');
        end;

        DataCompression.OpenZipArchive(InStream, false);
        DataCompression.GetEntryList(EntryList);

        Window.Open('#1##############################');

        TotalCount := 0;
        DeleteAll();
        foreach EntryListKey in EntryList do begin
            Init;
            "File Name" :=
                CopyStr(FileMgt.GetFileNameWithoutExtension(EntryListKey), 1, MaxStrLen("File Name"));
            "File Extension" :=
                CopyStr(FileMgt.GetExtension(EntryListKey), 1, MaxStrLen("File Extension"));
            TempBlob.CreateOutStream(EntryOutStream);
            //DataCompression.ExtractEntry(EntryListKey, EntryOutStream, Length); Dropped On Version 23
            TempBlob.CreateInStream(EntryInStream);

            if not IsNullGuid(Picture.ImportStream(EntryInStream, FileMgt.GetFileName(EntryListKey))) then begin
                Window.Update(1, "File Name");
                "File Size (KB)" := Length;
                TotalCount += 1;
                if StrLen("File Name") <= MaxStrLen(Item."Old Member No.") then
                    Item.Reset();
                Item.SetRange("Old Member No.", "File Name");
                if Item.FindFirst() then begin
                    "Item No." := Item."Member No.";
                    "Item Description" := Item.Description;
                    if Item."Signature ID".Count > 0 then begin
                        "Picture Already Exists" := true;
                        if ReplaceMode then
                            "Import Status" := "Import Status"::Pending;
                    end else
                        "Import Status" := "Import Status"::Pending;
                end;
                Insert;
            end;
        end;

        DataCompression.CloseZipArchive;
        Window.Close;

        if ServerFileOpened then
            //ServerFile.Close;
        exit(ZipFileName);
    end;

    [Scope('Cloud')]
    procedure ImportPictures(ReplaceMode: Boolean)
    var
        Item: Record "Image Data";
        Window: Dialog;
        ImageID: Guid;
    begin
        Window.Open('#1############################################');

        if Findset() then
            repeat
                if "Import Status" = "Import Status"::Pending then
                    if ("Item No." <> '') and ShouldImport(ReplaceMode, "Picture Already Exists") then begin
                        Window.Update(1, "Item No.");

                        Item.Reset();
                        Item.SetRange("Member No.", "Item No.");
                        if Item.FindFirst() then
                            ImageID := Picture.MediaId;
                        if "Picture Already Exists" then
                            Clear(Item."Picture ID");
                        Item."Picture ID".Insert(ImageID);
                        Item.Modify();
                        "Import Status" := "Import Status"::Completed;
                        Modify;
                    end;
            until Next() = 0;

        Window.Close;
    end;

    procedure ImportSignature(ReplaceMode: Boolean)
    var
        Item: Record "Image Data";
        Window: Dialog;
        ImageID: Guid;
    begin
        Window.Open('#1############################################');

        if Findset() then
            repeat
                if "Import Status" = "Import Status"::Pending then
                    if ("Item No." <> '') and ShouldImport(ReplaceMode, "Picture Already Exists") then begin
                        Window.Update(1, "Item No.");

                        Item.Reset();
                        Item.SetRange("Member No.", "Item No.");
                        if Item.FindFirst() then
                            ImageID := Picture.MediaId;
                        if "Picture Already Exists" then
                            Clear(Item."Signature ID");
                        Item."Signature ID".Insert(ImageID);
                        Item.Modify();
                        "Import Status" := "Import Status"::Completed;
                        Modify;
                    end;
            until Next() = 0;

        Window.Close;
    end;

    local procedure ShouldImport(ReplaceMode: Boolean; PictureExists: Boolean): Boolean
    begin
        if not ReplaceMode and PictureExists then
            exit(false);

        exit(true);
    end;

    [Scope('Cloud')]
    procedure GetAddCount(): Integer
    var
        TempItemPictureBuffer2: Record "Image Data Buffer" temporary;
    begin
        TempItemPictureBuffer2.Copy(Rec, true);
        TempItemPictureBuffer2.SetRange("Import Status", "Import Status"::Pending);
        TempItemPictureBuffer2.SetRange("Picture Already Exists", false);
        exit(Count);
    end;

    [Scope('Cloud')]
    procedure GetAddedCount(): Integer
    var
        TempItemPictureBuffer2: Record "Image Data Buffer" temporary;
    begin

        TempItemPictureBuffer2.Copy(Rec, true);
        TempItemPictureBuffer2.SetRange("Import Status", "Import Status"::Completed);
        TempItemPictureBuffer2.SetRange("Picture Already Exists", false);
        exit(Count);
    end;

    [Scope('Cloud')]
    procedure GetReplaceCount(): Integer
    var
        TempItemPictureBuffer2: Record "Image Data Buffer" temporary;
    begin

        TempItemPictureBuffer2.Copy(Rec, true);
        TempItemPictureBuffer2.SetRange("Import Status", "Import Status"::Pending);
        TempItemPictureBuffer2.SetRange("Picture Already Exists", true);
        exit(Count);
    end;

    [Scope('Cloud')]
    procedure GetReplacedCount(): Integer
    var
        TempItemPictureBuffer2: Record "Image Data Buffer" temporary;
    begin

        TempItemPictureBuffer2.Copy(Rec, true);
        TempItemPictureBuffer2.SetRange("Import Status", "Import Status"::Completed);
        TempItemPictureBuffer2.SetRange("Picture Already Exists", true);
        exit(Count);

    end;

}



