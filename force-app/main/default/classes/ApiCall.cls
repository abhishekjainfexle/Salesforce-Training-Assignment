public without sharing class ApiCall {
    public static Boolean fetchSmartyApi(String street, String city, String state) {
        if (String.isNotBlank(street) && String.isNotBlank(city) && String.isNotBlank(state)) {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setHeader('Content-type', 'application/json');
            request.setHeader('Host', 'us-street.api.smarty.com');

            // Encoding URL parameters
            String encodedStreet = EncodingUtil.urlEncode(street, 'UTF-8');
            String encodedCity = EncodingUtil.urlEncode(city, 'UTF-8');
            String encodedState = EncodingUtil.urlEncode(state, 'UTF-8');

            String endpoint = 'https://us-street.api.smarty.com/street-address?' +
                'auth-id=124281fc-2bf5-d3d8-8694-12260e6c5bf3' +
                '&auth-token=4JrmoNeBR6DE7ylvWiA5' +
                '&street=' + encodedStreet +
                '&city=' + encodedCity +
                '&state=' + encodedState +
                '&candidates=10'; 

            request.setEndpoint(endpoint);
            request.setMethod('GET');

            try {
                HttpResponse response = http.send(request);
                System.debug('Response Body: ' + response.getBody());

                if (response.getStatusCode() == 200) {
                    List<SmartyAddressWrapper> smartyAddressWrapperResponse =
                        (List<SmartyAddressWrapper>) JSON.deserialize(response.getBody(), List<SmartyAddressWrapper>.class);

                    System.debug('Parsed Response: ' + smartyAddressWrapperResponse);

                    // Check if the response city matches the input city
                    if (!smartyAddressWrapperResponse.isEmpty() && smartyAddressWrapperResponse[0].components != null) {
                        String responseCity = smartyAddressWrapperResponse[0].components.city_name;
                        System.debug('Response City: ' + responseCity);
                        return responseCity.equalsIgnoreCase(city); // Case-insensitive comparison
                    }
                } else {
                    System.debug('Error: ' + response.getBody());
                }
            } catch (Exception e) {
                System.debug('Exception in API call: ' + e.getMessage());
            }
        }
        return false;
    }

    public class SmartyAddressWrapper {
        public Integer input_index;
        public Integer candidate_index;
        public String delivery_line_1;
        public String last_line;
        public String delivery_point_barcode;
        public String smarty_key;
        public SmartyComponents components;
        public SmartyMetadata metadata;
        public SmartyAnalysis analysis;
    }

    public class SmartyComponents {
        public String primary_number;
        public String street_name;
        public String street_suffix;
        public String city_name;
        public String state_abbreviation;
        public String zipcode;
        public String plus4_code;
        public String delivery_point;
        public String delivery_point_check_digit;
    }

    public class SmartyMetadata {
        public String record_type;
        public String zip_type;
        public String county_fips;
        public String county_name;
        public String carrier_route;
        public String congressional_district;
        public String rdi;
        public String elot_sequence;
        public String elot_sort;
        public Decimal latitude;
        public Decimal longitude;
        public Integer coordinate_license;
        public String precision;
        public String time_zone;
        public Integer utc_offset;
        public Boolean dst;
    }

    public class SmartyAnalysis {
        public String dpv_match_code;
        public String dpv_footnotes;
        public String dpv_cmra;
        public String dpv_vacant;
        public String dpv_no_stat;
        public String active;
        public String footnotes;
    }
}