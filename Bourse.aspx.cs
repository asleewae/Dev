using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using System.Globalization;

public partial class Bourse : System.Web.UI.Page
{
    string[,] stocks = new string[0, 0];

    string[,] bel20 = {
            { "60128205", "AB InBev", "BE0003793107", "ABI"},
            { "60115758", "Ackermans & van Haaren", "BE0003764785", "ACKB"},
            { "60011766", "Ageas", "BE0974264930", "AGS"},
            { "60115832", "Befimmo Sicafi", "BE0003678894", "BEFB"},
            { "60115401", "Bekaert", "BE0974258874", "BEKB"},
            { "60187045", "Belgacom", "BE0003810273", "BELG"},
            { "60010228", "bpost", " BE0974268972", "BPOST"},
            { "60115774", "Cofinimmo", "BE0003593044", "COFB"},
            { "60115403", "Colruyt", "BE0974256852", "COLR"},
            { "60114919", "Delhaize Groupe", "BE0003562700", "DELB"},
            { "60115404", "D'Ieteren", "BE0974259880", "DIE"},
            { "60189206", "Elia", "BE0003822393", "ELI"},
            { "60115780", "GBL", "BE0003797140", "GBLB"},
            { "360194010", "GDF Suez", "FR0010208488", "GSZ"},
            { "60114924", "KBC Groupe", "BE0003565737", "KBC"},
            { "60011725", "Solvay", "  BE0003470755", "SOLB"},
            { "60189683", "Telenet Groupe Holding", "BE0003826436", "TNET"},
            { "60191463", "ThromboGenics", "BE0003846632", "THR"},
            { "60114926", "UCB", "BE0003739530", "UCB"},
            { "60115409", "Umicore", "BE0003884047", "UMI"}
        };

    string[,] cac40 = {
            { "360015751", "Accor", "FR0000120404 ", "AC"},
            { "360017018", "Air Liquide", "FR0000120073", "AI"},
            { "365019496", "Alstom", "FR0010220475", "ALO"},
            { "360114899", "Airbus Group", "NL0000235190", "AIR"},
            { "360017033", "Alcatel-Lucent", "FR0000130007", "ALU"},
            { "60115832", "ArcelorMittal", "LU0323134006", "MT"},
            { "360017035", "AXA", "FR0000120628", "CS"},
            { "360017012", "BNP Paribas", "FR0000131104", "BNP"},
            { "360017041", "Bouygues", "FR0000120503", "EN"},
            { "360097430", "Cap Gemini", "FR0000125338", "CAP"},
            { "360017027", "Carrefour", "FR0000120172", "CA"},
            { "360148977", "Crédit Agricole", "FR0000045072", "ACA"},
            { "360015757", "Danone", "FR0000120644", "BN"},
            { "360194025", "EDF", "FR0010242511", "EDF"},
            { "360114898", "Essilor", "FR0000121667", "EI"},
            { "360194010", "GDF Suez", "FR0010208488", "GSZ"},
            { "360191811", "Gemalto", "NL0000400653 ", "GTO"},
            { "360114906", "Kering", "FR0000121485", "KER"},
            { "360015789", "Lafarge", "FR0000120537", "LG"},
            { "360195912", "Legrand", "FR0010307819", "LR"},
            { "360017060", "L'Oréal", "FR0000120321", "OR"},
            { "360017053", "LVMH", "FR0000121014", "MC"},
            { "360017056", "Michelin B", "FR0000121261", "ML"},
            { "360099258", "Orange", " FR0000133308", "ORA"},
            { "360017067", "Pernod Ricard", "FR0000120693", "RI"},
            { "360114907", "Publicis Groupe", "FR0000130577", "PUB"},
            { "360017068", "Renault", "FR0000131906", "RNO"},
            { "360114909", "Safran", "FR0000073272", "SAF"},
            { "360111223", "Saint-Gobain", "FR0000125007", "SGO"},
            { "360114910", "Sanofi", "FR0000120578", "SAN"},
            { "360017074", "Schneider Electric", "FR0000121972", "SU"},
            { "360017048", "Société Générale", "FR0000130809", "GLE"},
            { "60011725", "Solvay", "BE0003470755", "SOLB"},
            { "360115968", "Technip", "FR0000131708", "TEC"},
            { "360105223", "Total", "FR0000120271", "FP"},
            { "360115972", "Unibail-Rodamco", "FR0000124711", "UL"},
            { "360115974", "Vallourec", "FR0000120354", "VK"},
            { "360115976", "Veolia Environnement", "FR0000124141", "VIE"},
            { "360115975", "VINCI", "FR0000125486", "DG"},
            { "360099251", "Vivendi", "FR0000127771", "VIV"}
        };

    string[,] mescours = {
            { "360194010", "GDF Suez", "FR0010208488", "GSZ"}
        };

    protected void prtData()
    {
        //sélection du tableau via QueryString
        if (Request.QueryString["stocks"] == "bel20")
            stocks = (string[,])bel20.Clone();
        else if (Request.QueryString["stocks"] == "cac40")
            stocks = (string[,])cac40.Clone();
        else if (Request.QueryString["stocks"] == "mescours")
            stocks = (string[,])mescours.Clone();
        
        string prtCoursInfos = string.Empty;
        string prtTableauCours = string.Empty;

        //boucle qui parcoure le tableau de marchés
        for (int i = 0; i < stocks.GetLength(0); i++)
        {
            //connection au service de données d'un cours
            var BourseService = "http://1.ajax.lecho.be/rtq/?reqtype=simple&quotes=" + stocks[i, 0];
            string serviceURL = string.Format(BourseService);
            string dwml = string.Empty;

            //télécharger les données de l'url
            WebClient webClient = new WebClient();
            dwml = webClient.DownloadString(serviceURL);

            var json = dwml;

            //retirer les chaînes non utilisables du flux
            string[] sDel = new string[] {
                "try { _parseRtq(",
                "}}) } catch(err) { console.error(err); }",
                "\"stocks\":{\"" + stocks[i,0] + "\":{"
            };

            foreach (string s in sDel)
            {
                //Entiers de début et de fin de chaine
                int iDelStart = json.IndexOf(s);
                int iDelEnd = s.Length;
                //Suppression à partir de ces entiers 
                json = json.Remove(iDelStart, iDelEnd);
            }

            //Dé-sérialiser les données vers la classe CoursInfos
            CoursInfos cours = JsonConvert.DeserializeObject<CoursInfos>(json);

            //Représenatation des données
            string colorPct = string.Empty;
            if (cours.last == cours.prev)
                colorPct = "black";
            else if(cours.last > cours.prev)
                colorPct = "green";
            else if(cours.last < cours.prev)
                colorPct = "red";

            var CapEch = cours.last * cours.volume;

            CultureInfo ci = new CultureInfo("fr-be");

            prtCoursInfos += "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"300\" style=\"border:1px solid #e2e2e2;padding:10px;margin:10px;\">" +
                "<tr>" +
                    "<td><span class=\"Titre\">" + stocks[i, 1] + "</span></td>" +
                "</tr><tr>" +
                    "<td><span class=\"SousTitre\">" + stocks[i, 3] + " " + stocks[i, 2] + "</span></td>" +
                "</tr><tr>" +
                    "<td>" +
                        "<table border=\"0\" cellpadding=\"4\" cellspacing=\"2\" style=\"border:1px solid #e2e2e2;padding:5px;margin:5px;\">" +
                        "<tr>" +
                            "<td colspan=\"2\" align=\"left\" nowrap><span class=\"valCours\"><b>" + cours.last.ToString("N02", ci) + " &euro;</b></span></td>" +
                            "<td colspan=\"2\" align=\"left\" nowrap><span class=\"valCours\" style=\"color:" + colorPct + "\"><b>" + (cours.pct / 100).ToString("P02", ci) + "</b></span></td>" +
                        "<tr>" +
                            "<td align=\"left\" valign=\"top\" bgcolor=\"#e2e2e2\" nowrap>Ouverture </td>" +
                            "<td align=\"right\" nowrap>" + cours.open.ToString("N02", ci) + " &euro;</td>" +
                            "<td align=\"left\" valign=\"top\" bgcolor=\"#e2e2e2\" nowrap>Clot. Préc. </td>" +
                            "<td align=\"right\" nowrap>" + cours.prev.ToString("N02", ci) + " &euro;</td>" +
                        "</tr><tr>" +
                            "<td align=\"left\" valign=\"top\" bgcolor=\"#e2e2e2\" nowrap>Haut </td>" +
                            "<td align=\"right\" nowrap>" + cours.high.ToString("N02", ci) + " &euro;</td>" +
                            "<td align=\"left\" valign=\"top\" bgcolor=\"#e2e2e2\" nowrap>Bas </td>" +
                            "<td align=\"right\" nowrap>" + cours.low.ToString("N02", ci) + " &euro;</td>" +
                        "</tr><tr>" +
                            "<td align=\"left\" valign=\"top\" bgcolor=\"#e2e2e2\" nowrap>Volume </td>" +
                            "<td align=\"right\" nowrap>" + cours.volume.ToString("N00", ci) + "</td>" +
                            "<td align=\"left\" valign=\"top\" bgcolor=\"#e2e2e2\" nowrap>Cap. éch. </td>" +
                            "<td align=\"right\" nowrap>" + CapEch.ToString("N00", ci) + " &euro;</td>" +
                        "</tr>" +
                        "</table>" +
                    "</td>" +
                "</tr><tr>" +
                    "<td style=\"padding-top:10px;padding-bottom:10px;\">" +
                        "<div style=\"width:1200px; overflow:auto;border:1px solid #e2e2e2\">" +
                        "<table border=\"0\" cellpadding=\"0\" cellspacing=\"5\">" +
                        "<tr>" +
                            "<td align=\"center\" class=\"TitGraph\">1 semaine</td>" +
                            "<td align=\"center\" class=\"TitGraph\">1 mois</td>" +
                            "<td align=\"center\" class=\"TitGraph\">3 mois</td>" +
                            "<td align=\"center\" class=\"TitGraph\">1 an</td>" +
                            "<td align=\"center\" class=\"TitGraph\">5 ans</td>" +
                        "</tr>" +
                        "<tr>" +
                            "<td align=\"left\" valign=\"top\" style=\"border:1px solid #e2e2e2;padding:10px;\">" +
                            "<img src=\"http://dchart.charting.eurobench.nl/tchart/tchart.aspx?user=Tijdnet&issue=" + stocks[i, 0] + "&layout=2010&startdate=1w&enddate=today&res=endofday&width=270&height=130&format=image/gif&culture=fr-BE\"" +
                            "</td>" +
                            "<td align=\"left\" valign=\"top\" style=\"border:1px solid #e2e2e2;padding:10px;\">" +
                            "<img src=\"http://dchart.charting.eurobench.nl/tchart/tchart.aspx?user=Tijdnet&issue=" + stocks[i, 0] + "&layout=2010&startdate=1m&enddate=today&res=endofday&width=270&height=130&format=image/gif&culture=fr-BE\"" +
                            "</td>" +
                            "<td align=\"left\" valign=\"top\" style=\"border:1px solid #e2e2e2;padding:10px;\">" +
                            "<img src=\"http://dchart.charting.eurobench.nl/tchart/tchart.aspx?user=Tijdnet&issue=" + stocks[i, 0] + "&layout=2010&startdate=3m&enddate=today&res=endofday&width=270&height=130&format=image/gif&culture=fr-BE\"" +
                            "</td>" +
                            "<td align=\"left\" valign=\"top\" style=\"border:1px solid #e2e2e2;padding:10px;\">" +
                            "<img src=\"http://dchart.charting.eurobench.nl/tchart/tchart.aspx?user=Tijdnet&issue=" + stocks[i, 0] + "&layout=2010&startdate=1y&enddate=today&res=endofday&width=270&height=130&format=image/gif&culture=fr-BE\"" +
                            "</td>" +
                            "<td align=\"left\" valign=\"top\" style=\"border:1px solid #e2e2e2;padding:10px;\">" +
                            "<img src=\"http://dchart.charting.eurobench.nl/tchart/tchart.aspx?user=Tijdnet&issue=" + stocks[i, 0] + "&layout=2010&startdate=5y&enddate=today&res=endofday&width=270&height=130&format=image/gif&culture=fr-BE\"" +
                            "</td>" +
                        "</tr>" +
                        "</table>" +
                        "</div>" +
                    "</td>" +
                "</tr>" +
            "</table>";

            prtTableauCours += "<td><span class=\"valCours\" style=\"color:" + colorPct + "\"><b>" + (cours.pct / 100).ToString("P02", ci) + "</b></span></td>";
        }

        Response.Write(prtCoursInfos);
    }

    protected CoursInfos Get_Data()
    {
        //boucle qui parcoure le tableau de marchés
        for (int i = 0; i < stocks.GetLength(0); i++)
        {
            //connection au service de données d'un cours
            var BourseService = "http://1.ajax.lecho.be/rtq/?reqtype=simple&quotes=" + stocks[i, 0];
            string serviceURL = string.Format(BourseService);
            string dwml = string.Empty;

            //télécharger les données de l'url
            WebClient webClient = new WebClient();
            dwml = webClient.DownloadString(serviceURL);

            var json = dwml;

            //retirer les chaînes non utilisables du flux
            string[] sDel = new string[] {
                "try { _parseRtq(",
                "}}) } catch(err) { console.error(err); }",
                "\"stocks\":{\"" + stocks[i,0] + "\":{"
            };

            foreach (string s in sDel)
            {
                //Entiers de début et de fin de chaine
                int iDelStart = json.IndexOf(s);
                int iDelEnd = s.Length;
                //Suppression à partir de ces entiers 
                json = json.Remove(iDelStart, iDelEnd);
            }

            //Dé-sérialiser les données vers la classe CoursInfos
            CoursInfos cours = JsonConvert.DeserializeObject<CoursInfos>(json);

            //Représenatation des données
            string colorPct = string.Empty;
            if (cours.last == cours.prev)
                colorPct = "black";
            else if (cours.last > cours.prev)
                colorPct = "green";
            else if (cours.last < cours.prev)
                colorPct = "red";
            var CapEch = cours.last * cours.volume;
            return (cours);
        }
    }
    
    protected void Page_Load(object sender, EventArgs e)
    {
        Label1.Text = cours.last.ToString("N02", ci);
    }

    //string[] MesCours = new string[0];

    protected void Button1_Click(object sender, EventArgs e)
    {
        //Response.Write(MesCours[0]);
    }
}