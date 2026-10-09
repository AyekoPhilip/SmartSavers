codeunit 50061 "Login Management Events"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"System Initialization", 'OnAfterLogin', '', false, false)]
    local procedure CheckTimeNotAllowed()
    var
        UserSetup: Record "User Setup";
        HRSetup: Record "Human Resources Setup";
        User: Record User;
        OverHours: Boolean;
        AllowLoginFrom: Time;
        AllowLoginTo: Time;
        NotAllowedToAccessErr: Label 'You are only allowed to access the system from %1. Kindly contact your administrator for assistance';
    begin

     /*   if UserSetup.Get(UserId) then begin
            if not UserSetup."Allow Login After Hours" then begin
                if TimeNotAllowed(time) then
                    Error(NotAllowedToAccessErr, Time);
            end;
        end;  */
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"System Initialization", 'OnAfterLogin', '', false, false)]
    local procedure CheckMultipleLogins()
    var
        UserSetup: Record "User Setup";
        User: Record User;
        ActiveSession: Record "Active Session";
        NotAllowedMultipleLoginsErr: Label 'You are not  allowed to have multiple logins in the system. Kindly contact your administrator for assistance';
    begin
        
     /*  User.Reset();
        User.SetRange("User Security ID", UserSecurityId());
        if User.FindFirst() then begin

            UserSetup.Reset();
            UserSetup.SetRange("User ID", User."User Name");
            if UserSetup.FindFirst() then begin
                UserSetup.TestField("Multiple Login");

                if not UserSetup."Allow Login After Hours" then begin

                    ActiveSession.Reset();
                    ActiveSession.SetRange("User ID", UserSetup."User ID");
                    ActiveSession.SetRange("Client Type", ActiveSession."Client Type"::"Web Client");
                    if ActiveSession.FindFirst() then begin
                        if ActiveSession.Count > UserSetup."Multiple Login" then
                            Error(NotAllowedMultipleLoginsErr);
                    end;
                end;
            end
        end;   */
    end;

    local procedure TimeNotAllowed(LoginTime: Time): Boolean
    var
        UserSetup: Record "User Setup";
        User: Record User;
        OverHours: Boolean;
        AllowLoginFrom: Time;
        AllowLoginTo: Time;
    begin
     /*  if (Format(AllowLoginFrom) = '') and (Format(AllowLoginTo) = '') then begin
            if UserId <> '' then
                if UserSetup.Get(UserId) then begin
                    UserSetup.TestField("Allow Posting From [Time]");
                    UserSetup.TestField("Allow Posting To [Time]");

                    AllowLoginFrom := UserSetup."Allow Posting From [Time]";
                    AllowLoginTo := UserSetup."Allow Posting To [Time]";
                end;
        end;
        exit((LoginTime < AllowLoginFrom) or (LoginTime > AllowLoginTo));  */
    end;
}


