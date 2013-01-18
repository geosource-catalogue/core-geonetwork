package org.fao.geonet.guiservices.csw.virtual;

import jeeves.constants.Jeeves;
import jeeves.interfaces.Service;
import jeeves.resources.dbms.Dbms;
import jeeves.server.ServiceConfig;
import jeeves.server.UserSession;
import jeeves.server.context.ServiceContext;
import jeeves.utils.PasswordUtil;
import jeeves.utils.Util;
import org.fao.geonet.constants.Geonet;
import org.fao.geonet.constants.Params;
import org.jdom.Element;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletContext;

//=============================================================================

/** Update the virtual CSW server informations
*/

public class Update implements Service
{

	public void init(String appPath, ServiceConfig params) throws Exception {}

	
	
	public Element exec(Element params, ServiceContext context) throws Exception
	{
		String operation = Util.getParam(params, Params.OPERATION);
		String id  = params.getChildText(Params.ID);
		String paramId = params.getChildText(Params.ID);
		
		String servicename = Util.getParam(params, Params.SERVICENAME);
		String classname = Util.getParam(params, Params.CLASSNAME);
		String servicedescription = Util.getParam(params, Params.SERVICEDESCRIPTION, "");
		
		HashMap<String, String> filters = new HashMap<String, String>();
		filters.put(Params.FILTER_ANY, Util.getParam(params, Params.FILTER_ANY, ""));
		filters.put(Params.FILTER_TITLE, Util.getParam(params, Params.FILTER_TITLE, ""));
		filters.put(Params.FILTER_SUBJECT, Util.getParam(params, Params.FILTER_SUBJECT, ""));
		filters.put(Params.FILTER_KEYWORD, Util.getParam(params, Params.FILTER_KEYWORD, ""));
		filters.put(Params.FILTER_DENOMINATORFROM, Util.getParam(params, Params.FILTER_DENOMINATORFROM, ""));
		filters.put(Params.FILTER_DENOMINATORTO, Util.getParam(params, Params.FILTER_DENOMINATORTO, ""));
		filters.put(Params.FILTER_TYPE, Util.getParam(params, Params.FILTER_TYPE, ""));
		filters.put(Params.FILTER_CATALOG, Util.getParam(params, Params.FILTER_CATALOG, ""));
		filters.put(Params.FILTER_GROUP, Util.getParam(params, Params.FILTER_GROUP, ""));
		filters.put(Params.FILTER_CATEGORY, Util.getParam(params, Params.FILTER_CATEGORY, ""));

		
		Dbms dbms = (Dbms) context.getResourceManager().open (Geonet.Res.MAIN_DB);

		if (operation.equals(Params.Operation.NEWSERVICE)) {

			String query = "SELECT * FROM Services WHERE name=?";
			Element servicesTest = dbms.select(query, servicename);

			
			if (servicesTest.getChildren().size() != 0){ 
				throw new IllegalArgumentException("Service with name "	+ servicename + " already exists");
			}
			
			id = String.format("%s",context.getSerialFactory().getSerial(dbms, "Services"));
			query = "INSERT INTO services (id, name, class, description) VALUES (?, ?, ?, ?)";
			dbms.execute(query, new Integer(id), servicename, classname, servicedescription);


			for (Map.Entry<String, String> filter : filters.entrySet()) {
				if (filter.getValue()!=null && !filter.getValue().equals("")){
					paramId = String.format( "%s" , context.getSerialFactory().getSerial(dbms, "ServiceParameters"));
					query = "INSERT INTO serviceParameters (id, service, name, value) VALUES (?, ?, ?, ?)";
					dbms.execute(query, new Integer(paramId), new Integer(id), filter.getKey() ,  filter.getValue());
				}
			}
		}
		
		else if (operation.equals(Params.Operation.UPDATESERVICE)) {
			
			for (Map.Entry<String, String> filter : filters.entrySet()) {
				
				String query = "SELECT * FROM ServiceParameters WHERE service=? AND name=?";
				Element testParams = dbms.select(query, id, filter.getKey());
				
				if (testParams.getChildren().size() != 0){ 
					query = "UPDATE serviceParameters SET value=? WHERE service=? AND name=?";
					dbms.execute (query, filter.getValue(), id, filter.getKey());
				} else {
					paramId = String.format( "%s" , context.getSerialFactory().getSerial(dbms, "ServiceParameters"));
					query = "INSERT INTO serviceParameters (id, service, name, value) VALUES (?, ?, ?, ?)";
					dbms.execute(query, new Integer(paramId), new Integer(id), filter.getKey() ,  filter.getValue());
					
				}
				
				
				query = "UPDATE services SET description=? WHERE name=?";
				dbms.execute(query, servicedescription, servicename );

			
			}
			
		}
		

		return new Element(Jeeves.Elem.RESPONSE);
	}




}

//=============================================================================

