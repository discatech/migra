create schema if not exists "evenbetterschema";

create extension if not exists "citext" with schema "public" version '1.6';

create extension if not exists "hstore" with schema "public" version '1.7';

create type "public"."bug_status" as enum ('new', 'open', 'closed');

create sequence "public"."bug_id_seq";

create sequence "public"."products_product_no_seq";

DO
$$
    BEGIN
        IF (SELECT 1
            FROM information_schema.tables
            WHERE table_schema = 'public'
              AND table_name = 'products'
        ) THEN
            REVOKE select on table "public"."products" from "postgres";
        END IF;
    END
$$;

alter table "public"."products" drop constraint "products_name_key";

alter table "public"."products" drop constraint "products_x_key";

alter table "public"."products" drop constraint "products_z_fkey";

alter table "public"."products" drop constraint "products_zz_fkey";

alter table "public"."products" drop constraint "x";

drop materialized view if exists "public"."matvvv";

drop view if exists "public"."vvv";

alter table "public"."aunwanted" drop constraint "aunwanted_pkey";

drop index if exists "public"."aunwanted_pkey";

drop index if exists "public"."orders_order_id_idx";

drop index if exists "public"."products_name_key";

drop index if exists "public"."products_price_idx";

drop index if exists "public"."products_x_idx";

drop index if exists "public"."products_x_key";

drop table "public"."aunwanted";

drop table "public"."columnless_table";

alter type "public"."shipping_status" rename to "shipping_status__old_version_to_be_dropped";

create type "public"."shipping_status" as enum ('not shipped', 'shipped', 'delivered');

alter type "public"."unused_enum" rename to "unused_enum__old_version_to_be_dropped";

create type "public"."unused_enum" as enum ('a', 'b', 'c');

create table "public"."bug" (
    "id" integer not null default nextval('bug_id_seq'::regclass),
    "description" text,
    "status" text
);


create table "public"."columnless_table2" (
);


create table "public"."order_items" (
    "product_no" integer not null,
    "order_id" integer not null,
    "quantity" integer
);


alter table "public"."orders" alter column status type "public"."shipping_status" using status::text::"public"."shipping_status";

drop type "public"."shipping_status__old_version_to_be_dropped";

drop type "public"."unused_enum__old_version_to_be_dropped";

alter table "public"."change_to_logged" set logged;

alter table "public"."change_to_unlogged" set unlogged;

alter table "public"."orders" add column "h" hstore;

alter table "public"."orders" alter column "order_id" drop default;

alter table "public"."orders" alter column "status2" set data type text using "status2"::text;

DO
    $$
        BEGIN
            IF (SELECT 1
                FROM information_schema.columns
                WHERE table_schema = 'public'
                  AND table_name = 'products'
                  AND column_name = 'oldcolumn'
            ) THEN
                alter table "public"."products" drop column "oldcolumn";
            END IF;
        END
    $$;

DO
    $$
        BEGIN
            IF (SELECT 1
                FROM information_schema.columns
                WHERE table_schema = 'public'
                  AND table_name = 'products'
                  AND column_name = 'z'
            ) THEN
                alter table "public"."products" drop column "z";
            END IF;
        END
    $$;

DO
    $$
        BEGIN
            IF (SELECT 1
                FROM information_schema.columns
                WHERE table_schema = 'public'
                  AND table_name = 'products'
                  AND column_name = 'zz'
            ) THEN
                alter table "public"."products" drop column "zz";
            END IF;
        END
    $$;

alter table "public"."products" add column "newcolumn" text;

alter table "public"."products" add column "newcolumn2" interval;

alter table "public"."products" alter column "name" drop not null;

alter table "public"."products" alter column "name" set data type text using "name"::text;

alter table "public"."products" alter column "price" set default 100;

alter table "public"."products" alter column "price" set not null;

alter table "public"."products" alter column "product_no" set default nextval('products_product_no_seq'::regclass);

alter table "public"."products" alter column "product_no" set not null;

alter table "public"."products" alter column "x" drop default;

alter table "public"."products" alter column "x" drop not null;

alter sequence "public"."bug_id_seq" owned by "public"."bug"."id";

alter sequence "public"."products_product_no_seq" owned by "public"."products"."product_no";

drop sequence if exists "public"."aunwanted_id_seq";

drop sequence if exists "public"."orders_order_id_seq";

drop type "public"."unwanted_enum";

drop extension if exists "pg_trgm";

CREATE UNIQUE INDEX order_items_pkey ON public.order_items USING btree (product_no, order_id);

CREATE INDEX products_name_idx ON public.products USING btree (name);

CREATE UNIQUE INDEX products_pkey ON public.products USING btree (product_no);

DO
    $$
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'order_items_pkey') THEN
                alter table "public"."order_items" add constraint "order_items_pkey" PRIMARY KEY using index "order_items_pkey";
        END IF;
    END
$$;

DO
    $$
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'products_pkey') THEN
                alter table "public"."products" add constraint "products_pkey" PRIMARY KEY using index "products_pkey";
        END IF;
    END
$$;

DO
    $$
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'order_items_order_id_fkey') THEN
                alter table "public"."order_items" add constraint "order_items_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE;
        END IF;
    END
$$;

DO
    $$
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'order_items_product_no_fkey') THEN
                alter table "public"."order_items" add constraint "order_items_product_no_fkey" FOREIGN KEY (product_no) REFERENCES products(product_no) ON DELETE RESTRICT;
        END IF;
    END
$$;

DO
    $$
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'y') THEN
                alter table "public"."products" add constraint "y" CHECK ((price > (0)::numeric));
        END IF;
    END
$$;

DO
    $$
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'x') THEN
                alter table "public"."products" add constraint "x" CHECK ((price > (10)::numeric));
        END IF;
    END
$$;

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.newfunc(i integer, t text[])
 RETURNS TABLE(a text, c integer)
 LANGUAGE plpgsql
 STABLE STRICT
AS $function$
 declare
        BEGIN
                select 'no', 1;
        END;

$function$
;

CREATE OR REPLACE FUNCTION public.changed(i integer, t text[])
 RETURNS TABLE(a text, c integer)
 LANGUAGE plpgsql
 STRICT SECURITY DEFINER
AS $function$
 declare
        BEGIN
                select 'no', 1;
        END;

$function$
;

create materialized view "public"."matvvv" as  SELECT 2;


create or replace view "public"."vvv" as  SELECT 2;


grant update on table "public"."products" to "postgres";

drop schema if exists "badschema";
