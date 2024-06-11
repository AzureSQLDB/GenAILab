![A picture of the Microsoft Logo](./media/graphics/microsoftlogo.png)

# Create and Connect to an Azure SQL Database

The next section of the workshop you will be creating and connecting to an Azure SQL Database.

![A picture of the Azure SQL DB Logo](./media/ch2/sqldb1.png)

## Azure SQL Database create and connect workshop tasks

### Create a free Azure SQL Database

1. Ensure you have an Azure account to log into the Azure Portal. Need a free account? Sign up for one [here](https://azure.microsoft.com/en-us/free).

    **NOTE: (You can skip this step if you are using a Skillable VM instance)**

1. Navigate to the [Azure Portal](https://portal.azure.com/#home), and in the upper left corner, click the menu button.

    ![A picture of selecting the menu in the upper left corner of the Azure Portal](./media/ch2/deploy1a.png)

1. Then, select **Create a Resource**.

    ![A picture of selecting Create a Resource from the Azure Portal menu](./media/ch2/deploy1b.png)

1. In the category menu, select **Databases**.

    ![A picture of selecting Database from the category menu](./media/ch2/deploy1c.png)

1. Then click **create** for **SQL Database**.

    ![A picture of selecting create for SQL Database](./media/ch2/deploy1d.png)

1. On the **Create SQL Database** page, click the **Apply offer (Preview)** button for the free Azure SQL Database.

    ![A picture of clicking the Apply offer (Preview) button for the free Azure SQL Database on the Create SQL Database page](./media/ch2/deploy1e.png)

1. In the **Project details** section of the page, select a subscription and a Resource group if you have an existing one. 

    ![A picture of select a subscription and a Resource group on the Project details section of the page](./media/ch2/deploy1f.png)

    Otherwise you can create a Resource group by clicking the **Create new** button.

    ![A picture of creating a Resource group by clicking the **Create new** button](./media/ch2/deploy1g.png)

1. Next, in the **Database details** section of the page, name your database **freeDB** with the **Database name** field.

    ![A picture of naming your database with the Database name field in the Database details section of the page](./media/ch2/deploy1h.png)

1. For the **Server**, click the **Create new** button.

    ![A picture of naming your database with the Database name field in the Database details section of the page](./media/ch2/deploy1i.png)

1. On the **Create SQL Database Server** page, enter a **server name** and choose a **Location** using the dropdown menu.

    ![A picture of entering a server name and choosing a Location using the dropdown menu on the Create SQL Database Server page](./media/ch2/deploy1j.png)

1. Now, in the **Authentication** section, select the **radio button** for **Use Microsoft Entra-only authentication**.

    ![A picture of selecting the radio button for Use both SQL and Microsoft Entra authentication in the authentication section](./media/ch2/deploy1k.png)

1. Click the **Set admin** link in the **Set Microsoft Entra admin** section. 

    ![A picture of clicking the Set admin link in the Set Microsoft Entra admin section](./media/ch2/deploy1l.png)

1. Using the **Microsoft Entra ID** blade, find your user account and select it as an admin. Then click the **Select** button on the bottom left.

    ![A picture of select your account as the Entra ID admin](./media/ch2/deploy1m.png)

1. Click the **OK** button on the bottom left of the page.

    ![A picture of clicking the OK button at the bottom of the authentication page](./media/ch2/deploy1m1.png)

1. Back on the **Create a SQL Database** page, verify the values you entered and that the free database offer has been applied. 

    ![A picture of verifying the values and that the free database offer has been applied](./media/ch2/deploy1o.png)

1. On the top of the page, click on the **Additional settings** tab.

    ![A picture of clicking on the Additional settings tab](./media/ch2/deploy11a.png)

1. On the Additional settings page, find the **Data source** section on the top.

    ![A picture of the Data source section on the Additional settings page](./media/ch2/deploy11b.png)

1. Use the **Use existing data** toggle

    ![A picture of the Use existing data toggle](./media/ch2/deploy11c.png)

    to set it to **Sample** by clicking on it.

    ![A picture of clicking on the sample option of the Use existing data toggle](./media/ch2/deploy11d.png)

    and in the pop-up dialog, select **OK** for the question **"Do you want to continue"**.

    ![A picture of selecting OK for the question Do you want to continue in the pop-up dialog](./media/ch2/deploy11e.png)

1. On the bottom of the page in the lower left, click the **Review + create** blue button.

    ![A picture of clicking the Review + create blue button](./media/ch2/deploy11f.png)

1. On the following page, click the **Create** button in the lower left.

    ![A picture of clicking the Create button in the lower left](./media/ch2/deploy1p.png)

1. The following page will detail the deployments progress. *(Deployment takes a minute or 2)*

    ![A picture of the database deployment progress page](./media/ch2/deploy1q.png)

1. Once the deployment is done, click the blue **Go to resource** button to see your database details.

    ![A picture of clicking the blue Go to resource button to see your database details on the database deployment progress page](./media/ch2/deploy1r.png)

#### Network access to the database

1. On the database details page, the right hand side, you will see the **Server name** field with a link the your database server. Click the server name link.

    ![A picture of clicking the server name link on the database details page](./media/ch2/deploy1s.png)

1. Click the **Networking** link on the left hand side menu in the **Security** section.

    ![A picture of clicking the Networking link on the left hand side menu in the Security section](./media/ch2/deploy1t.png)

1. On the **Networking** page, click the **radio button** next to **Selected networks**.

    ![A picture of clicking the radio button next to Selected networks on the networking page](./media/ch2/deploy1u.png)

1. In the **Firewall rules** section, click the button labeled **"Add your client IPv4 address (X.X.X.X)"** to add your local IP address for database access.

    ![A picture of clicking the button labeled "Add your client IPv4 address (X.X.X.X)" to add your local IP address for database access](./media/ch2/deploy1v.png)

1. Finally, click the **Save** button in the lower left of the page.

    ![A picture of clicking the save button in the lower left of the page](./media/ch2/deploy1x.png)

### Connect to the free Azure SQL Database

#### Using Visual Studio Code

Visual Studio Code will be used for working with the database.

1. Using the menu on the left side, open the menu items under **Settings** if not already opened. Then select **Azure SQL Databases** by clicking on it.

    ![A picture of clicking the Azure SQL Databases option under settings](./media/ch2/deploy2a.png)

1. Next, on the main page, find the freeDB you created and click on it navigate to the database details page.

    ![A picture of clicking the freeDB SQL Databases](./media/ch2/deploy2b.png)

1. On the SQL Database overview page, **Getting Started** tab for the database details. Here click on the blue **Open in Visual Studio Code** button.

    ![A picture of clicking on the blue Open in Visual Studio Code button](./media/ch2/deploy3a.png)

1. On the following page, if Visual Studio Code is not installed, click on the blue **Download Visual Studio Code** button to start that process. If it is already installed or was just installed, click on the **Launch it now** link.

    ![A picture of downloading or launching Visual Studio Code from the Azure portal](./media/ch2/deploy3b.png)

1. After clicking **Launch it now**, the browser will have a modal window saying "This site is trying to open Visual Studio Code". Click the **Open** button.

    ![A picture of click the Open button in the browser dialog box](./media/ch2/deploy3b1.png)

1. When Visual Studio Code opens, click the SQL Extension on the left side.

    ![A picture of clicking the SQL Server vs code extension on the left side](./media/ch2/deploy3b2.png)

1. Next, click **Add Connection** in the SQL Extension.

    ![A picture of clicking Add Connection in the SQL Extension](./media/ch2/deploy3b3.png)

1. On the top of Visual Studio Code, a dialog box will appear asking for a **Server Name or ADO.NET connection string**.

    ![A picture of a dialog box will appearing asking for a Server Name or ADO.NET connection string](./media/ch2/deploy3b4.png)

    Enter the **server name** of your Free Azure SQL Database instance. You can find and copy this value on the Azure SQL Database details page back in the Azure Portal.

    *You may have to click the X in the upper right corner of the "Start Modern Data Workflow in Visual Studio Code" Page to return to the SQL Overview page.*

    ![A picture of a dialog box will appearing asking for a Server Name or ADO.NET connection string](./media/ch2/deploy3b5.png)

    then press enter/return in the dialog box.

1. The next dialog box asks for the **Database Name**. Enter **freeDB** (the name if the database you created) and press enter/return.

    ![A picture of entering freeDB in the dialog box and pressing enter/return](./media/ch2/deploy3b6.png)

1. For the Authentication type dialog box, choose **Microsoft Entra Id**.

    ![A picture of chooseing Microsoft Entra Id ror the Authentication type dialog box](./media/ch2/deploy3b7.png)

1. In the following dialog box, you are asked to **Choose a Microsoft Entra account**. Choose **Add a Microsoft Entra account...**. 

    ![A picture of selecting the Add a Microsoft Entra account](./media/ch2/deploy3e.png)

    and authenticate via Edge and the Azure portal.

    ![A picture of authenticating via the Azure portal](./media/ch2/deploy3e1.png)

    Once authenticated, you can close the browser tab and return to Visual Studio Code.

    ![A picture of a successful authentication via the Azure portal](./media/ch2/deploy3e2.png)

1. When you return to Visual Studio Code, the last dialog box asks you to **name the connection profile**. Name it **freeDB** and press enter/return.

   ![A picture of a naming the connection profile freeDB](./media/ch2/deploy3e3.png)

1. Once connected to the database, right click on the connection name in the connection navigator on the left side and choose **New Query**.

    ![A picture of right clicking on the connection name in the connection navigator on the left side and choosing New Query](./media/ch2/deploy3f.png)

