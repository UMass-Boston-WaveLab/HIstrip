classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        rfbase < hgsetget & matlab.mixin.Copyable & JavaVisible 

%rfbase.rfbase class
%
%    rfbase.rfbase properties:
%       Name - Property is of type 'string' (read only)
%
%    rfbase.rfbase methods:
%       checkfrequency - Check the frequency.
%       checkproperty - Check the properties of the object.
%       checkreadonlyproperty - Check the read only property.
%       destroy - Destroy this object
%       disp - display object.
%       interpolate - Interpolate the data using INTERP1 function.
%       scalingfrequency - Scale frequency data.
%       scalingpower - Scale power data.
%       setcomplex - set function for complex scalar.
%       setcomplexmatrix - set function for complex matrix.
%       setcomplexvector - set function for complex vector.
%       setintptype - set function for interpolation type.
%       setnegativevector - set function for negative real vector.
%       setnetworkparametertype - set function for the type of
%                                     network parameters.
%       setnoisefigure - set function for noise figure.
%       setpositive - set function for positive scalar.
%       setpositivevector - set function for positive real vector.
%       setrealvector - set function for real vector.


    properties (SetAccess=protected, SetObservable)
        %NAME Property is of type 'string' (read only)
        Name = '';
    end
    methods 
        function set.Name(obj,value)
            if ~isequal(obj.Name,value)
                % DataType = 'string'
%                obj.Name = sethandle(obj,value);
%                 sethandle(obj);
                obj.Name = value;
            end
        end
    end   % set and get functions for Name

    properties (Hidden)
        %COPYPROPERTYOBJ Property is of type 'bool' 
        CopyPropertyObj = true;
    end

    properties (Hidden)
        %PROPERTYCHANGED Property is of type 'bool' 
        PropertyChanged = true;
    end

    properties (Hidden)
        %BLOCK Property is of type 'string' 
        Block = '';
    end

    methods  % method signatures
    
        result = checkfrequency(h,freq)
        enum_member = checkenum(h,prop_name,input_str,enum_list,varargin)
        enum_member = checkenumexact(h,prop_name,input_str,enum_list,   ...
            varargin)
        % Change varargin to varargin_not, should minic what matlab does
        % and not what name implies by position
        checkreadonlyproperty(h,varargin_not,names)
        checkproptype(h, value, prop_name, prop_type)
        checkrealscalardouble(h, prop_name, val)
        checkbool(h, prop_name, val)
        h = destroy(h,destroyData)
        disp(h)
        newy = interpolate(h,x,y,newx,method)
        [fname,freq,funit,sfactor] = scalingfrequency(h,in,funit)
        [pname,pdata,punit] = scalingpower(h,in,format,power_type)
        out = setcomplex(h,out,prop,empty_allowed,updateflag,           ...
            zero_allowed)
        out = setcomplexmatrix(h,out,prop,empty_allowed,updateflag)
        out = setcomplexvector(h,out,prop,empty_allowed,                ...
            updateflag,zero_allowed)
        out = setintptype(h,out,prop,empty_allowed,updateflag)
        out = setnegativevector(h,out,prop,zero_included,               ...
            inf_included,empty_allowed,updateflag)
        out = setnetworkparametertype(h,out,prop, empty_allowed,updateflag)
        out = setnoisefigure(h,in,prop,isavector)
        out = setpositive(h,out,prop,zero_included,                     ...
            inf_included,empty_allowed,updateflag)
        out = setpositivevector(h,out,prop,zero_included,               ...
            inf_included,empty_allowed,updateflag)
        out = setrealvector(h,out,prop,zero_included,                   ...
            inf_included,empty_allowed,updateflag)
    end  % method signatures

    methods (Abstract)   % Makes this class abstract
        checkproperty(h)
    end

    methods (Access = protected)
        copyObj = copyElement(h)
    end

end  % classdef
