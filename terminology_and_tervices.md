# Terminology and services

## Terminology:

**MLS**: This is an acronym for Multiple Listing Service, which is something like a huge house listing database(and other relevant information) where Real Estate professionals have access. Only licensed agents and brokers can access to this services and post(for example) a new home.
There are around 600 MLS in USA, and of course, the more MLS an agent have access, the more properties he/she can provide to his/her customers. It’s important to mention that this services doesn’t provide APIs to be used for third-party platforms(like Cher).

**RETS**: This is an acronym for Real Estate Transaction Standard, which is a standard that allows developers to retrieve data from multiple MLS. This is a very robust standard and since it’s a bit complicated to use it, industry has been working in more modern solutions(API), but this is a WIP.
There are a couple of tools developed that might help you to use RETS: <https://www.reso.org/rets-tools/>

**User**: In Cher's world this is used to refer to no-professionals who are registered in the platform.

**Customer**: Real Estate and similar professional roles registered in platform. Professional, Agent, Real Estate and Brokers are words that can be used to refer same thing.

**Prospect**: Every potential platform user(not registered in cher.app)

**Comunication Master Template**: Refers to a [spreadsheet](https://docs.google.com/spreadsheets/u/1/d/1RFkU3qVgYS4Qra6RLnANVcQCGnEp5GWi/edit?usp=drive_web&ouid=101945000112240114740&rtpof=true) document that controls the relation action-content on all the cher.app comunication modules(invitations, sharing items, welcome emails, modals...)


## Used technologies for properties data:

* **SimplyRETS**:
  This is a tool we use like a middleware to get properties from the diferent MLS Cher have access to. Once MLS access is granted to Cher, we add it to the vendors list on SimplyRETS by the given MLS’s credentials. Once an MLS is added as a vendor, a sync process is started, and the vendor can be used once the sync is done. How much time does the sync take depends of the number of properties the new MLS have.

  What SimplyRETS does is provide an easy way to request properties through an API.(Remember that RETS is a mess)
  Link to documentation: <https://docs.simplyrets.com/>
  We are currently using only */properties* and */openhouses* endpoints.
  If for some reason you need to contact support, you can send an email to *support@simplyrets.com*, response doesn’t take more than one day.

* **Attom Data Solutions**:
  It is suppose that this is a datawherehouse, so this tool give us a lot of information about properties. This services is used as a complement in the property overview page. Even though they offer multiple endpoints(each one return different data), we are currently using only three of them: *property/detail*, *saleshistory/detail* and *salestrend/snapshot*.
  You can find all the available endpoints here: <https://api.developer.attomdata.com/docs>

## Technologies that posible will be implemented:

* **Contra Costa**: On their own woords:

  > [Contra Costa Association of REALTORS](https://ccartoday.com) is part of the largest professional trade association in the United States, the National Association of REALTORS® (NAR) and the statewide organization, the California Association of REALTORS® (C.A.R.). CCAR and the CCAR Multiple Listing Service (MLS) provide members with innovative products and resources to help them excel in their businesses and serve the community with integrity, professionalism and state-of-the-art real estate technology.

  They offer a service called IDX Center that provide listings through RETS. Since is one of the biggest listing service, Cher is interested in replace SimplyRETS with IDX Center.
  We currently have access to this service but implementation stills pending.
  Here is the only resource about this service: <https://ccartoday.com/mls-resources-information/idx-center/>


## Previously researched technologies:

* **IDX Broker**: Service that provides real estate data through widgets. This is the first service that was thought to be implemented in cher.app. It was discarted because of the limitation that they don't provide raw data.
**IDX Broker** is not the same as **IDX Center** by **Contra Costa**.
