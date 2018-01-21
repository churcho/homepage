import * as React from "react";
import { MainNav, ActiveItem } from "./../components/MainNav";
import { ChangePasswordForm } from "./../components/ChangePasswordForm";
import { OneTimeLoginLink } from "./../components/OneTimeLoginLink";

export const SettingsRoute = () => (
  <div>
    <MainNav activeItem={ActiveItem.Settings} />
    <ChangePasswordForm />
    <OneTimeLoginLink />
  </div>
);