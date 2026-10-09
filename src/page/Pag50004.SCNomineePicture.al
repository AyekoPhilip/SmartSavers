page 50004 "SC Nominee Picture"
{
    Caption = 'Nominee Picture';
    PageType = CardPart;
    SourceTable = "Collateral Register";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Picture; Rec.Picture)
                {

                    ApplicationArea = All;
                    ShowCaption = false;
                    ToolTip = 'Specifies the value of the Picture field.';
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(TakePicture)
            {
                ApplicationArea = All;
                Caption = 'Take';
                Image = Camera;
                ToolTip = 'Activate the camera on the device.';
                Visible = CameraAvailable;

                trigger OnAction()
                begin
                    TakeNewPicture;
                end;
            }
            action(ImportPicture)
            {
                ApplicationArea = All;
                Caption = 'Import';
                Image = Import;
                ToolTip = 'Import a picture file.';

                trigger OnAction()
                var
                    FileManagement: Codeunit "File Management";
                    FileName: Text;
                    ClientFileName: Text;
                    AllFilesDescriptionTxt: Label 'All Files (*.*)|*.*', Comment = '{Split=r''\|''}{Locked=s''1''}';
                    PicInstream: InStream;
                begin
                    Rec.TestField("ID/Passport");
                    if Rec."Account No." = '' then
                        Error(MustSpecifyNameErr);

                    if Rec.Picture.HasValue then
                        if not Confirm(OverrideImageQst) then
                            exit;

                    UploadIntoStream('Select a picture to upload', '', AllFilesDescriptionTxt, FileName, PicInstream);
                    if FileName = '' then
                        exit;

                    Clear(Rec.Picture);
                    Rec.Picture.ImportStream(PicInstream, Rec."ID/Passport");
                    //Rec.Picture.ImportFile(FileName, ClientFileName);
                    if not Rec.Modify(true) then
                        Rec.Insert(true);
                end;
            }
            action(ExportFile)
            {
                ApplicationArea = All;
                Caption = 'Export';
                Enabled = DeleteExportEnabled;
                Image = Export;
                ToolTip = 'Export the picture to a file.';

                trigger OnAction()
                var
                    DummyPictureEntity: Record "Picture Entity";
                    FileManagement: Codeunit "File Management";
                    ToFile: Text;
                    ExportPath: Text;
                begin
                    Rec.TestField("ID/Passport");
                    Rec.TestField("Account No.");
                    ToFile := DummyPictureEntity.GetDefaultMediaDescription(Rec);
                    /* ExportPath := TemporaryPath + Rec."ID No." + Format(Rec.Picture.MediaId);
                    Rec.Picture.ExportFile(ExportPath);
                    FileManagement.ExportImage(ExportPath, ToFile); */
                end;
            }
            action(DeletePicture)
            {
                ApplicationArea = All;
                Caption = 'Delete';
                Enabled = DeleteExportEnabled;
                Image = Delete;
                ToolTip = 'Delete the record.';

                trigger OnAction()
                begin
                    Rec.TestField("ID/Passport");

                    if not Confirm(DeleteImageQst) then
                        exit;

                    Clear(Rec.Picture);
                    Rec.Modify(true);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetEditableOnPictureActions;
    end;

    trigger OnOpenPage()
    begin
        CameraAvailable := Camera.IsAvailable();
    end;

    var
        Camera: Codeunit Camera;
        
        CameraAvailable: Boolean;
        OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
        DeleteImageQst: Label 'Are you sure you want to delete the picture?';
        SelectPictureTxt: Label 'Select a picture to upload';
        DeleteExportEnabled: Boolean;
        MustSpecifyNameErr: Label 'You must specify a customer name before you can import a picture.';
        MimeTypeTok: Label 'image/jpeg', Locked = true;

    procedure TakeNewPicture()
    var
        PictureInstream: InStream;
        PictureDescription: Text;
    begin
        Rec.Find();
        Rec.TestField("ID/Passport");
        Rec.TestField("Account No.");

        if Rec.Picture.HasValue() then
            if not Confirm(OverrideImageQst) then
                exit;

        if Camera.GetPicture(PictureInstream, PictureDescription) then begin
            Clear(Rec.Picture);
            Rec.Picture.ImportStream(PictureInstream, PictureDescription, MimeTypeTok);
            Rec.Modify(true)
        end;
    end;

    local procedure SetEditableOnPictureActions()
    begin
        DeleteExportEnabled := Rec.Picture.HasValue;
    end;

    procedure IsCameraAvailable(): Boolean
    begin
        exit(Camera.IsAvailable());
    end;
}



