import * as React from "react";

import { MainNav } from "@components/MainNav";
import { Incr } from "@components/Incr";

export const HomeRoute = () => (
  <div>
    <MainNav activeItem={"home"} />
    <Incr />
  </div>
);
