&if "{5}" = "" &then
cast(lib.core.Factory:Instance:GetInstance("{1}"), {3})
&else
cast({5}:GetInstance("{1}"), {3})
&endif
