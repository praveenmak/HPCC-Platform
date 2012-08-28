/*##############################################################################

    Copyright (C) <2010>  <LexisNexis Risk Data Management Inc.>

    All rights reserved. This program is NOT PRESENTLY free software: you can NOT redistribute it and/or modify
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
############################################################################## */

isUnique1(set of integer x) := function
    ds1 := dataset(x, { integer value1; });
    ds2 := dataset(x, { integer value2; });
    return not exists(ds1(count(ds2(ds1.value1 = ds2.value2)) > 1));
END;

isUnique2(set of integer x) := function
    ds1 := dataset(x, { integer value; });
    return count(x) = count(dedup(sort(ds1, value), value));
END;

set of integer values := [1,2,3,4,5,6,7] : stored('values');

output(isUnique1(values));
output(isUnique2(values));
